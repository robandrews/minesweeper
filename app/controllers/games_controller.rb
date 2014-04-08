class GamesController < ApplicationController
  include GamesHelper
  
  def new
  end

  def create
    x_dim = params[:board_x].to_i
    y_dim = params[:board_y].to_i
    bombs = params[:num_bombs].to_i
    @game = Game.new(x_dim, y_dim, bombs)
    @game.run
    @grid = @game.board.print_board
    render :show
  end
end
