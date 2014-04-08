require "./tile"

class Board
  attr_accessor :tiles
  attr_reader :bomb_loc 

  def initialize size_x, size_y, num_bombs
    @size_x = size_x
    @size_y = size_y
    @num_bombs = num_bombs
    @tiles = Array.new(size_x) {Array.new(size_y)}
    @win = false
    @lose = false
    @bomb_loc = []
  end

  def print_board
    
    arr = Array.new(@size_x){Array.new(@size_y)}
    @tiles.each_with_index do |row, index|
      row.each_index do |column|
        arr[index][column] = display_value(@tiles[index][column])
      end
    end
    grid = Grid.new(arr, @size_x, @size_y)
    grid.draw_grid
  end

  def make_bomb_loc
    rand_pos = []
    until rand_pos.length == @num_bombs do
      rand_pos << [rand(@size_x), rand(@size_y)]
    end
    p "Bomb locations #{rand_pos}"
    @bomb_loc = rand_pos
  end

  def populate_board
    bomb_locs = make_bomb_loc
    @tiles.each_with_index do |row, index|
      row.each_index do |column|
        if bomb_locs.include?([index, column])
          @tiles[index][column] = Tile.new([index,column],true, self)
        else
          @tiles[index][column] = Tile.new([index,column],false, self)
        end
      end
    end
    nil
  end
  
  def display_value(tile)
    if tile.visited
      if tile.bomb
        'B'
      elsif tile.neighbor_bomb_count.zero?
        '_'
      else
        return tile.neighbor_bomb_count
      end
    elsif tile.flagged
      'F'
    else
      '*'
    end
  end
  
end