require 'dxruby'
require_relative './sprites/skill_list.rb'
require_relative './sprites/character.rb'
require_relative './sprites/data.rb'
require_relative './sprites/home.rb'
require_relative './sprites/battle.rb'
require_relative './sprites/window.rb'
require_relative './sprites/timer.rb'
require_relative './sprites/texts.rb'
require_relative './sprites/ui.rb'
require_relative './sprites/player.rb'

# 作りかけ
Game_data.new
UI.new
Battle_UI.new
Home_UI.new
Home.new
Battle.new
Texts.new
window = Game_window.new
window.display
