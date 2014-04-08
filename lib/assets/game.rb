require "./board" 
require "./grid"
require "yaml"

class Minesweeper
  attr_accessor :board
  
  def initialize(board_x, board_y, num_bombs)
    @board = Board.new(board_x, board_y, num_bombs)
  end
  
  def run
    @t1 = Time.now
    puts "Welcome to Minesweeper!"
    @board.populate_board
    

    until won? || lost?
      @board.print_board
      input = prompt_user
      if input[0] == "r"
        @last_turn = @board.tiles[input[1].to_i][input[2].to_i].reveal
      else
        @board.tiles[input[1].to_i][input[2].to_i].flag
      end
    end
  end
  
  def prompt_user
    
    puts "Please enter move with the \'r\' prefix for reveal and the \'f\' prefix for flag."
    puts "For example: f(2,3) to flag position 2,3 or r(3,4) to reveal position 3,4"
    puts "The coordinate system starts a zero, from the top left"
    puts "Enter the word \'save\' to save your game state to the directory"
    
    begin
      input = gets.chomp
      parsed = input.scan(/\A([fr])\((\d),(\d)\)\z/)
      if parsed.empty? && input.downcase != "save"
        raise "Invalid input"
      end
      
      save_game if input.downcase == "save"
    rescue
      puts "Sorry, invalid format.  Please try again with format: \'r(2,3)\'"
      retry
    end
    parsed.flatten
  end
  
  def save_game
    
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
  
  def save_game
    t = Time.now
    f = File.open("#{t.month}-#{t.day}-#{t.year}_#{t.hour}-#{t.min}.mine", "w") do |line|
      
      line.write(@board.to_yaml)
      
    end
    
  end
end

g = Minesweeper.new(5,5,2)