class AddColToGame < ActiveRecord::Migration
  def change
    add_column :games, :board, :text
  end
end
