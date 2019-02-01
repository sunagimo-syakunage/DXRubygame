# 基礎的なステータスと通常攻撃
# 名前、体力、攻撃力、属性、防御したかどうか、生きているか、初期体力、最大体力、初期攻撃力、経験値がいじれる
# 正直attr_accessorがどうなってるかわからない
class Character
  attr_accessor :name, :hp, :strength, :element, :defence_flg, :alive_flg, :ini_hp, :max_hp, :ini_strength, :exp
  include Skill_list

  def initialize(name, hp, strength, element, exp = 0, defence_flg = false, alive_flg = true)
    @name = name
    @exp = exp
    @hp = hp
    @ini_hp = hp
    @max_hp = hp
    @strength = strength
    @ini_strength = strength
    @element = element
    @defence_flg = defence_flg
    @alive_flg = alive_flg
  end

  # 通常攻撃
  # 結局スキルリストにまとめてもいいかも
  def atk(other)
    str = []
    # 十分の一の確率でクリティカルいまのところ通常攻撃にしか実装してない
    if rand(10) == 1
      str << "#{name}の攻撃 クリティカルヒット！\n"
      damege_calc(other, 1.5)
      str << "#{other.name}の残りhpは#{other.hp}\n"
    else
      str << "#{name}の攻撃！\n"
      damege_calc(other)
      str << "#{other.name}の残りhpは#{other.hp}\n"
    end
    str.join
  end
end

# 基本的な敵 通常攻撃と3種類のスキルが使える
# test = Enemy.new("テスト君"", 5, 10,"blizzard",50,"fire_breath",60)のように書けば
# 名前がテスト君で体力が5攻撃が10で50%でブリザードを放ち10%でファイアブレスを放つ敵が作れる
# 後はUIに画像を関係をすればいい感じ
class Enemy < Character
  # sukillの初期値に通常攻撃(atk) スキル確率の初期値に100をいれる
  # これでいちいち全部入力しなくても埋めてくれる
  def initialize(name, hp, strength, element, exp, skill1 = 'atk', skill1p = 100, skill2 = 'atk', skill2p = 100, skill3 = 'atk', skill3p = 100)
    @skill1 = skill1
    @skill1p = skill1p
    @skill2 = skill2
    @skill2p = skill2p
    @skill3 = skill3
    @skill3p = skill3p
    super(name, hp, strength, element, exp)
  end

  def act(other)
    str = []
    # スキルを使うかの抽選
    str << case rand(100)
           when 0..@skill1p
             send(@skill1, other)
           when @skill1p + 1..@skill2p
             # ここ@skill1pの初期値が100だから101..100とかになっちゃう
             send(@skill2, other)
           when @skill2p + 1..@skill3p
             send(@skill3, other)
           else
             atk(other)
           end
    str.join
  end
end
