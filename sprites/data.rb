# モジュールにしてデータをモジュール関数にする手もあったけどハッシュにまとめるほうがメジャーなのかな？

class Game_data
  # data = Game_data.new().data_book
  # data[:player]
  # みたいに呼び出す
  def initialize
    # ==================プレイヤー==================
    @player = Player.new('主人公', 500, 2, 'normal')
    # ==================プレイヤーおわり==================
    # ==================エネミー==================
    # とりあえず作った敵
    # ("名前",体力,攻撃力,属性,倒した時の経験値,スキル1の名前,スキル1の確率,スキル2の名前,スキル2の確率、スキル3の名前,スキル3の確率)
    # スキルは引数がなくても動くよ
    # 新しく作ったらUIのイメージに追加しよう
    # たくさん作るとなるとちょっとめんどくさいかもしれないので
    # エネミーを作るメソッドを作るのもありかもしれない
    # bossはなまえの後にセリフが入れれる
    # でもメソッド側で条件分岐とかさせてセリフを変えたりもありかも
    # とりあえず敵のリスト ステージでエンカウントが違うから何個か作る
    @spi_fire = Enemy.new('ファイアスピリット', 10, 50, 'fire', 50, 'fire_breath', 50)
    @spi_ice = Enemy.new('アイススピリット', 25, 25, 'ice', 50, 'blizzard', 50)
    @boss_bear = Enemy.new('熊', 1000, 300, 'nomal', 100_000)
    # ==================エネミーおわり==================

    # ==================ハッシュはじめ==================
    @@data_book = {
      # ==================UI==================
      win_w: 800,
      win_h: 600,

      # ==================キャラクター==================
      # ==================エネミー==================
      spi_fire: @spi_fire,
      spi_ice: @spi_ice,
      boss_bear: @boss_bear,
      # enemylist
      # ("#{stage}_enemy_list").to_symで呼び出している
      forest_enemy_list: [{ enemy: @spi_fire, encount: 0..3 },
                          { enemy: @spi_ice, encount: 4..7 },
                          { enemy: @boss_bear, encount: 8..9 }],
      # forest_enemy_list: [@spi_fire, @spi_ice, @spi_fire, @spi_ice, @spi_fire, @spi_ice, @spi_fire, @spi_ice, @boss_bear],
      marine_enemy_list: [{ enemy: @boss_bear, encount: 0..9 }],
      # enemy_lists: [{ name: 'forest', list: @@background_forest },
      #               { name: 'marine', list: @@background_marine }]
      # ==================プレイヤー==================
      # 主人公を作る
      # プレイヤーはuiをみるからdataで宣言するならdataにuiを読み込ませるとか
      player: @player,
      # ==================キャラクター終わり==================

      # ==================ステージ関連==================
      stagelist: %w[forest marine]
      # ==================ステージ関連おわり==================

    }
  end

  def self.book
    @@data_book
  end
end
