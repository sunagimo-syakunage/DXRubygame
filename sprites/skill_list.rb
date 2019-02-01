module Skill_list
  # いちいち弱点かくのめんどいから技の属性だけ書いて解決するようにする予定
  # 弱点表みたいなのを作るとか
  # forest はまだ作ってないけどこんな感じに入れればできる
  @@element_list = [{ use: 'fire', weak: %w[ice forest], resist: ['fire'] },
                    { use: 'ice', weak: ['fire'], resist: ['ice'] }]

  def damege_calc(other, bairitu = 1, use = 'nomal')
    damege = strength * bairitu
    use_element = @@element_list.find { |abc| abc[:use] == use }
    if use_element && use_element[:weak].include?(other.element)
      damege *= 1.3
    elsif use_element && use_element[:resist].include?(other.element)
      damege *= 0.8
    end
    if other.defence_flg
      damege /= 2
      other.defence_flg = false
    end
    other.hp -= damege.round
  end

  def fire_breath(other)
    str = []
    str << "#{name}のファイアブレス\n"
    damege_calc(other, 1.2, 'fire')
    str << "#{other.name}の残りhpは#{other.hp}\n"
    str.join
  end

  def blizzard(other)
    str = []
    str << "#{name}のブリザード\n"
    damege_calc(other, 1.2, 'ice')
    str << "#{other.name}の残りhpは#{other.hp}\n"
    str.join
  end
end
