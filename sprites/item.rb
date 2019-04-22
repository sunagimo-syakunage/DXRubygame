class Item
  attr_accessor :name,:kosuu
  # itemの個数とかを管理するためにインスタンスを作るタイプ
  def initialize(name)
    @data = Game_data.book
    @player = @data[:player]
    @name = name
  end
end

class Heal_item < Item
  attr_accessor :name,:kosuu,:heal_value
  def initialize(name,heal_value)
    @name = name
    super(@name)
  end

  def use
    @player.hp += self.heal_value
    @player.hp = @player.max_hp if @player.hp > @player.max_hp
    self.kosuu -= 1
    str = []
    str << "#{self.name}を使った\n
            {#{@player.name}は体力が#{self.heal_value}回復した"
    str
  end
end

class
