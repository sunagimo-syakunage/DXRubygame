class Player < Character
  attr_accessor :level

  def initialize(name, hp, strength, element)
    @@player_item_box = []
    @level = 1
    super(name, hp, strength, element)
  end

  # def select()
  # uiを読んでるだけ
  # なのでこめんとあうと
  #   return UI.battle_read
  # end

  def self.item_box
    @@player_item_box
  end

  def attak(enemy)
    # 主人公用に特別な処理がなければUI.battle_readをatkにしてね
    atk(enemy)
  end

  def defence(_enemy)
    str = []
    str << "#{name}は身を守っている\n"
    self.defence_flg = true

    str.join
  end

  def escape(_enemy)
    str = []
    str << "#{name}は逃げ出した\n"
    # 7割で逃げれる
    if (0..6) === rand(10)
      Battle.escape
    else
      str << "しかし回り込まれてしまった！\n"
    end

    str.join
  end

  def battle_result
    str = []
    count = 0
    # 経験値表を作ってそれをインクリメントで進めていくのもあり
    while exp >= 100
      count += 1
      self.exp -= 100
    end
    # レベルが上がっているなら
    if count > 0
      # レベルとステータスを上げる
      self.level += count
      self.hp = (ini_hp * 0.5 * self.level).round
      self.max_hp = hp
      self.strength = (ini_strength * 1.1 * self.level).round
      str << "#{name}は#{count}レベル上がった"
    end
    str.join
  end
end
