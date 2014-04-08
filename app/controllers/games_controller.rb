class GamesController < ApplicationController
  include GamesHelper
  
  def new
  end

  def create
    x = params[:board_x].to_i
    y = params[:board_y].to_i
    bombs = params[:num_bombs].to_i
    instance = GamesHelper::MinesweeperGame.new(x, y, bombs)
    instance.run
    board = instance.board_yaml
    @game = Game.create(board: board)
    render :show
  end
end