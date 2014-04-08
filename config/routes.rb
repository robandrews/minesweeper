Minesweeper::Application.routes.draw do
  root to: "games#new"
  resources :games, :only => [:create, :new, :update, :show]

end
