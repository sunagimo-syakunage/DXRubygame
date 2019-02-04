class Stage
  attr_accessor :name,:stage_exp,:stage_exp_max
  # stageとか適当すぎるから例えば
  # エネミーみたいにステージのインスタンスの一つが森とか
  # 探索率もそれで管理する
  # dataに渡す
  # リクワイヤとかの関係でここでエネミーリストを宣言するのはやめよう
  def initialize(name,stage_exp_max)
    @name = name
    @stage_exp_max = stage_exp_max
    @stage_exp = 0
    # @@select = false
  end

  # def self.run
  #   Stage_UI.view
  #   @@select = false
  #   @@select = Stage_UI.stage_read if Input.mousePush?(M_LBUTTON)
  # end

  # def self.select
  #   @@select
  # end
end
