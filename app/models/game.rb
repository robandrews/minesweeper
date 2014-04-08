# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  board      :text
#

class Game < ActiveRecord::Base  
end
