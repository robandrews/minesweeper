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