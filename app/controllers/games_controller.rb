class GamesController < ApplicationController
  include GamesHelper

  def new
  end

  def create
    x = params[:board_x].to_i
    y = params[:board_y].to_i
    n = params[:num_bombs].to_i
    options = {board_x: x, board_y: y, num_bombs: n}
    instance = GamesHelper::MinesweeperGame.new(options)
    instance.run
    board = instance.board_yaml
    @game = Game.create(board: board)
    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    board = YAML.load(@game.board)
    options = {board: board}    
    instance = GamesHelper::MinesweeperGame.new(options)
    instance.user_input(params[:position])
    newboard = instance.board_yaml
    @game.update_attributes(board: newboard)
    render :show
  end
end