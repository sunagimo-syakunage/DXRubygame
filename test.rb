# @element_list =[{use: "fire",weak: ["ice","forest"],resist: ["file"]},
# {use:"ice",weak: ["fire"],resist: ["ice"]}]

#                   module Skill
#                     @@element_list =[{use: "fire",weak: ["ice","forest"],resist: ["file"]},
#                   {use:"ice",weak: ["fire"],resist: ["ice"]}]
# def skill_damege(use,element)
# puts @@element_list.find { |abc| abc[:use] == use }[:weak]
#     if @@element_list.select { |abc| abc[:use] == use }.first[:weak].include?(element)
#       puts "weak"
#     elsif   @@element_list.select { |abc| abc[:use] == use }.first[:resist].include?(element)
#       puts "resist"
#     end
# sleep(5)
# end
# end

# include Skill

# skill_damege("nomal","ice")

class Game_data
  def initialize
    @@data_book = {
      win_w: 'w',
      win_h: 'h',
      ui: 'ui',
      spi_fire: '@spi_fire',
      spi_ice: '@spi_ice',
      boss_bear: '@boss_bear',
      enemy_list: ['@spi_fire', '@spi_ice', '@spi_fire', '@spi_ice', '@spi_fire', '@spi_ice', '@spi_fir'],
      player: '@player'
    }
  end

  def self.book
    @@data_book
    end
end

Game_data.new

puts Game_data.book
sleep(5)
