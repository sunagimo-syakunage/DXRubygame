class Battle
  def initialize
    @@data = Game_data.book
    @@flg = 0
    # 戻り値用に配列の宣言
    @@str = []
    @@enemy = @@data[:spi_fire]
    @@player = @@data[:player]
    @@flg = 0
    @@battle_menu_flg = 0
    @@escape_flg = 0
    @@result_flg = 0

    # 今回はファイバーというのを利用しているので
    # そのファイバーを一回は宣言しないといけない
    # でもイニシャライズにめちゃくちゃ書くのは嫌だったので
    # メソッドに初期化を分けた
    battle_fiber

    @@encount_f.resume(true)
    # self.result
  end

  def battle_fiber
    @@encount_f = Fiber.new do
      # 戦闘が始まって一番初めのテキストを配列に追加
      @@str = ["#{@@enemy.name}が現れた"]
      # puts("1")

      # puts("c")

      # 戦うの呼び出し

      @@fight_f.resume(true) while Fiber.yield
    end
    @@fight_f = Fiber.new do
      scene = 'player'
      # puts("e")
      # どちらかの体力が0以下になるまで戦う
      while @@flg == 0
        case scene
        when 'player'

          # ボタンを表示するためにテキストを空白にするよ
          @@str = ['']
          # そしてボタンの呼び出し
          @@battle_menu_flg = 1

          # Fiber.yield というのは 次のよびだしまで待機する場所
          # 今回はクリックされるまでここで待機何もしません
          Fiber.yield

          # プレイヤーのセレクト呼び出しと代入
          @@select = Battle_UI.battle_read if Input.mousePush?(M_LBUTTON)
          #  @@selectがfalseでないつまり何か選択されたなら敵のターンに行くよ
          if @@select
            # ボタンを消す
            @@battle_menu_flg = 0
            # プレイヤーの選択に応じたメソッドを呼び出す
            @@str = [@@player.send(@@select, @@enemy)]
            # 逃げれたなら戦闘終了
            break if @@escape_flg == 1

            Fiber.yield
            # 選択されたのが実行されたので戻しとく
            @@select = false
            # 敵のターンへ
            scene = 'enemy'
          end
          # 敵を倒したかの判定
          if @@enemy.hp <= 0
            # エネミーは生きていません
            @@enemy.alive_flg = false
            # 勝ったフラグ
            @@flg = 1
            # 勝ったなら戦闘終了
            break
          end
        when 'enemy'
          # 敵の行動
          @@str = [@@enemy.act(@@player)]
          Fiber.yield
          # 負けたか判定
          if @@player.hp <= 0
            @@flg = 2
            @@player.alive_flg = false
            break
          end
          # プレイヤーのターンへ
          scene = 'player'
        end
      end
      # 戦闘が終わったのでリザルトを呼びます
      @@result_f.resume(true)
      @@result_f.resume(true) while Fiber.yield
    end
    @@result_f = Fiber.new do
      if @@flg == 1
        # 1は勝利なので勝利
        # エネミーの経験値をプレイヤーに加算
        @@player.exp += @@enemy.exp
        # レベルアップしてたらレベルアップの分を追加する
        # ちょっと適当なコード
        @@str = if @@player.exp >= 100
                  ["戦闘に勝利した\n" + @@player.battle_result]
                else
                  ["戦闘に勝利した\n"]
                end
        Fiber.yield
        @@result_flg = 'win'
      elsif @@flg == 2
        @@str = ["戦闘に敗北した\n"]
        # 負けたのでプレイヤーを回復させとく
        @@player.hp = @@player_oldhp
        Fiber.yield
        @@result_flg = 'lose'
      else
        # 勝ったか負けた以外なら逃げている具体的にはflg==0
        @@escape_flg = 0
        @@result_flg = 'escape'
      end
      # 敵の体力を初期状態に
      @@enemy.hp = @@enemy_oldhp
      @@flg = 0
      # @@result_flg = 1
      # 戦闘の初期化
      battle_fiber
    end
  end

  def self.encount
    # ステージに対応したenemy_listの呼び出し
    @@enemy_list = @@data["#{@stage}_enemy_list".to_sym]
    # 0~9のランダムな数字
    rand = rand(10)
    # そのランダムな数字を自分のエンカウント数列に含んだやつを返す
    @@enemy = @@enemy_list.select { |abc| abc[:encount] === rand }.first[:enemy]
    # 戦闘が終わったとき用に初期体力の保存
    @@enemy_oldhp = @@enemy.max_hp
    # 負けた時用に体力の保存
    @@player_oldhp = @@player.max_hp

    # 生きてます
    # エンカウントした時のよみがえらせてるから倒した後戻してない
    @@player.alive_flg = true
    @@enemy.alive_flg = true

    # プレイヤーの選択用
    @@select = false
  end

  def self.escape
    @@escape_flg = 1
  end

  def self.start(stage)
    puts @stage
    @stage = stage
    encount
    puts @stage
    @@str = []
    @@result_flg = 'run'
  end

  def self.end
    @@result_flg
  end

  def self.run
    # resume(true)にしているのは
    # while Fiber.yield()をうまく回すためwhileの判定のために
    # resumeに入れたものがyieldにはいってyieldにいれたものがresumeに入る
    # ファイバー分けて宣言て使いたいときに
    # if文に&&result_flg=="run"とか適当に書けば終わった後進まない
    Battle_UI.battle_view(@@enemy)
    Battle_UI.battle_menu if @@battle_menu_flg == 1
    @@encount_f.resume(true) if Input.mousePush?(M_LBUTTON)
    # バトルのすべての戻り値はテキストになっている
    @@str
    # バトルが終わってウィンドウループに戻る処理 今回は街とか戻るところもないのでつけない
    # window.flg = 0 if @@result_flg != 0
  end
end
