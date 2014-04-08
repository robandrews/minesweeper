module GamesHelper
  
  class MinesweeperGame
    attr_accessor :board
  
    def initialize(options)
      if options[:board]
        @board = options[:board]
      else
        @board = Board.new(options[:board_x], options[:board_y], options[:num_bombs])
      end
    end
    
    def run
      @t1 = Time.now
      @board.populate_board
    end
 
    
    def board_yaml
      @board.to_yaml
    end
  
    def user_input(input)
      # input = parse_input(input)
      # input = fix_offset(raw_input)
      input.unshift("r")
      
      
      if input[0] == "r"
        @last_turn = @board.tiles[input[1].to_i][input[2].to_i].reveal
      else
        @board.tiles[input[1].to_i][input[2].to_i].flag
      end
      @board.print_board
      #need to check for win.
    end

    # def fix_offset(raw)
    #   raw.unshift("r")
    #   raw[2] = raw[2]
    # end
    # def prompt_user
    #     
    #       puts "Please enter move with the \'r\' prefix for reveal and the \'f\' prefix for flag."
    #       puts "For example: f(2,3) to flag position 2,3 or r(3,4) to reveal position 3,4"
    #       puts "The coordinate system starts a zero, from the top left"
    #       puts "Enter the word \'save\' to save your game state to the directory"
    #     
    #       begin
    #         input = gets.chomp
    #         parsed = input.scan(/\A([fr])\((\d),(\d)\)\z/)
    #         if parsed.empty? && input.downcase != "save"
    #           raise "Invalid input"
    #         end
    #       
    #         save_game if input.downcase == "save"
    #       rescue
    #         puts "Sorry, invalid format.  Please try again with format: \'r(2,3)\'"
    #         retry
    #       end
    #       parsed.flatten
    #     end

    def parse_input(input)
      begin

        parsed = input.scan(/\A([fr])\((\d),(\d)\)\z/)
        if parsed.empty? && input.downcase != "save"
          raise "Invalid input"
        end
        
      rescue
        puts "Sorry, invalid format.  Please try again with format: \'r(2,3)\'"
        retry
      end
      
      parsed.flatten
      
    end
    
    def lost?
      if @last_turn == false
        puts "Game over :("
        puts "The bombs were at #{@board.bomb_loc.each{|pair| p pair}}"
        return true
      end
    end

    def won?
      bombs = @board.tiles.flatten.select{|tile| tile.bomb}
      if bombs.all?{|b| b.flagged}
        puts "You've won!"
        puts "It took you #{Time.now - @t1} seconds to solve the puzzle"
        return true
      end
    end
  
  end
  
  
  
  
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
  
  
  
  
  
  class Grid
    attr_accessor :contents
    def initialize(contents, horizontal = 8, vertical = 8, h_size=8, v_size=2)
      @vertical = vertical
      @horizontal = horizontal
      @h_size = h_size
      @v_size = v_size
      @contents = contents # || Array.new(horizontal, Array.new(vertical))
    end
  
    # need to make a method that center justifies the strings, so they are formatted properly when
    # we throw them into the draw_grid method.
    def draw_grid
      print_cap
      (0...@vertical).each do |vert_index|
        (0..@v_size).each do |block_height|
          (0...@horizontal).each do |horizontal_index|
            if block_height == (@v_size/2)
              print "|" + " "*(@h_size/2)
              "#{print @contents[horizontal_index][vert_index]}|"
              print " "*(@h_size/2-1)
            else
              print "|"; print " "*@h_size
            end
          end
          print "|\n" 
            
        end
        print_cap
      end
    end
    
    def print_cap
      print "+"; @horizontal.times{print "-"*@h_size + "+"}; print "\n"
    end
    
    
    # def draw_grid
#       @ret_str = ""
#       print_cap
#       (0...@vertical).each do |vert_index|
#         (0..@v_size).each do |block_height|
#           (0...@horizontal).each do |horizontal_index|
#             if block_height == (@v_size/2)
#               @ret_str += "|" + " "*(@h_size/2)
#               @ret_str += "#{@contents[horizontal_index][vert_index]}|"
#               @ret_str += " "*(@h_size/2-1)
#             else
#               @ret_str += "|"; 
#               @ret_str += " "*@h_size
#             end
#           end
#           @ret_str += "|\n" 
#             
#         end
#         print_cap
#       end
#       @ret_str
#     end
#     
    def size
      puts "This is a #{@horizontal} by #{@vertical} grid, (x,y)=(0,0) starts at upper left"
    end
#       
#     def print_cap
#       @ret_str += "+"
#       @horizontal.times{@ret_str += ("-"*@h_size + "+")}
#       @ret_str += "\n"
#     end
#   
  end
  
  
  
  
  
  
  
  
  class Tile
    attr_accessor :visited, :explored, :flagged
    attr_reader :bomb, :position
  
    def initialize position, bomb, board
      @bomb = bomb
      @position = position
      @flagged = false
      @explored = false
      @board = board
      @visited = false
    end

    def neighbors
      positions = [[1,0], [0,1], [1,1], [-1,0], [0,-1], [-1,-1], [1,-1], [-1,1]]
      offsets = positions.map do |offset|
        [self.position[0] + offset[0], self.position[1] + offset[1]]
      end

      @board.tiles.flatten.select{ |tile| offsets.include?(tile.position) }
    end

    def flag
      if @bomb
        @flagged = true 
      else
        puts "That's not a bomb - n00b"
      end
    end

    def reveal
      return false if @bomb
      return if @visited
      @visited = true
      #we want to reveal ALL neighbors if they are bomb free

      if neighbor_bomb_count.zero?
        self.neighbors.each { |neighbor| neighbor.reveal }
      end
    end

    def neighbor_bomb_count
      count = 0
      self.neighbors.each do |neighbor|
        count+=1 if neighbor.bomb
      end
      count
    end
  end
end
