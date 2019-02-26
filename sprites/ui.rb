class UI < Sprite
  def initialize
    @@data = Game_data.book
    @@win_w = @@data[:win_w]
    @@win_h = @@data[:win_h]
    #==================カーソル系==================
    # カーソルはdrawしないからイメージを作りたくないけど仕方ない
    # 初期位置は画面外に宣言している
    @@cursor = Sprite.new(-10, -10, Image.new(10, 10, [0, 0, 0]))
    # ==================プレイヤー系==================
    @@player = @@data[:player]
    @@player_img = Image.load('./media/character/hero.png')
    # ==================エネミ－系==================
    # 追加したらちゃんとenemy_imgsに追加しよう
    @@spi_fire_img = Image.load('./media/character/spi_fire.png')
    @@spi_ice_img = Image.load('./media/character/spi_ice.png')
    @@boss_bear_img = Image.load('./media/character/boss_bear.png')
    # linebotで教わった配列の中にハッシュをかく方法で名前で検索できる
    @@enemy_imgs = [{ name: 'ファイアスピリット', img: @@spi_fire_img },
                    { name: 'アイススピリット', img: @@spi_ice_img },
                    { name: '熊', img: @@boss_bear_img }]

    # ==================ステージ系==================
    @@background_home = Image.load('./media/background/home.png')
    @@background_forest = Image.load('./media/background/forest.png')
    @@background_marine = Image.load('./media/background/marine.png')
    @@background_imgs = [{ name: 'home', img: @@background_home },
                         { name: 'forest', img: @@background_forest },
                         { name: 'marine', img: @@background_marine }]
    # ==================テキスト系==================
    @@font_size = 32
    # テキストを置く場所作り
    @@text_field_width = @@win_w
    @@text_field_height = @@font_size * 5
    @@text_field_x = 0
    @@text_field_y = @@win_h - @@text_field_height
    # テキストの背景 灰色だけじゃさみしいので白の枠もかいとく
    @@text_field_background = Image.new(@@text_field_width, @@text_field_height, [50, 50, 50]).box(@@font_size / 2, @@font_size / 2, @@text_field_width - @@font_size / 2, @@text_field_height - @@font_size / 2, [255, 255, 255])
    # テキストがテキストフィールドのどこから始まるか
    @@text_x = @@text_field_x + @@font_size
    @@text_y = @@text_field_y + @@font_size
    # 今更だけどフォント
    # ドットものにする予定
    @@font = Font.new(@@font_size, font_name = 'MS Pゴシック')

    # ==================ボタン系==================
    # イメージの大きさをhome基準にするてもある
    @@cancel_img = Image.load('./media/button/cancel.png')
    @@img_width = @@cancel_img.width
    @@img_height = @@cancel_img.height
    @@img_margin = @@img_width
    @@button_left_margin = (@@text_field_width % (@@img_width + @@img_margin)) / 2

    # マウスオーバー時に出る画像
    @@hover = Image.new(@@img_width * 1.5, @@img_height * 1.5, [255, 255, 255])
    # ボタンの表示位置はここ 横は各自なので縦だけ
    # テキストフィールドの半分に来るようにする
    # この数値は画像の左上が来る位置を刺してることに注意
    @@buttons_y = @@text_field_y + @@text_field_height / 2 - @@img_width / 2
    @@cancel_button = [Sprite.new(@@button_left_margin + @@img_margin * 6 + @@img_width * 4.5, @@buttons_y, @@cancel_img), Sprite.new(@@button_left_margin + @@img_margin * 6 + @@img_width * 4.5, @@buttons_y, @@cancel_img.flush([50, 50, 50]))]

    # ==================バー系==================
    # 1メモリの大きさ
    @@block_width = 2
    @@block_height = 20
    # 各ブロックの色
    @@hp_block = Image.new(@@block_width, @@block_height, [50, 200, 100])
    @@exp_block = Image.new(@@block_width, @@block_height, [50, 200, 200])
    # 枠
    @@bar_border = 2
    @@bar_background_width = @@block_width * 100 + @@bar_border * 2
    @@bar_background_height = @@block_height + @@bar_border * 2
    # barが減ったと起用にbox_fillでかいとく
    @@bar_background = Image.new(@@bar_background_width, @@bar_background_height, [0, 0, 0]).box_fill(@@bar_border, @@bar_border, @@bar_background_width - @@bar_border - 1, @@bar_background_height - @@bar_border - 1, [230, 30, 30])
    @@exp_bar_background = Image.new(@@bar_background_width, @@bar_background_height, [0, 0, 0])
  end

  def self.background(here)
    background_img = @@background_imgs.select { |abc| abc[:name] == here }.first[:img]

    Window.draw(0, 0, background_img)
  end

  def self.text_field(str, k)
    # テキスト表示
    # strというのが文章の配列でkがインデックス
    # 見ようと思えばログが簡単に見れる
    Window.draw_font(@@text_x, @@text_y, str[k].to_s, @@font, z: 1)
    Window.draw(@@text_field_x, @@text_field_y, @@text_field_background)
  end

  def self.hp_bar(enemy)
    # プレイヤーとエネミーの体力をパーセントにできるように
    # 先にかける100.0があるのは実数にするため
    player_hp_p = (@@player.hp * 100.0 / @@player.max_hp).round
    enemy_hp_p = (enemy.hp * 100.0 / enemy.max_hp).round
    # プレイヤーが生きているなら
    if @@player.alive_flg
      (0...player_hp_p).each do |i|
        # パーセント分ブロックの表示
        Window.draw((@@win_w / 7 - 40).floor + i * @@block_width, @@player_img.height - @@font_size, @@hp_block, 50)
      end
      # 位置も面倒なので変数に宣言したほうがいいかも
      Window.draw_font((@@win_w / 7 - 42).floor, @@player_img.height, "HP: #{@@player.hp} | #{@@player.max_hp}", @@font, z: 1)
      Window.draw((@@win_w / 7 - 42).floor, @@player_img.height - @@font_size - @@bar_border, @@bar_background, 20)
    end
    if enemy.alive_flg
      (0...enemy_hp_p).each do |i|
        Window.draw(@@win_w * 5 / 7 - 40 + i * @@block_width, @@player_img.height - @@font_size, @@hp_block, 50)
      end
      Window.draw((@@win_w * 5 / 7 - 42).floor, @@player_img.height - @@font_size - @@bar_border, @@bar_background, 20)
    end
  end

  def self.exp_bar
    # まだ経験地表がないので今はいらないパーセント計算
    # player_exp_p = (player.exp* 100.0 / 100).round
    # hpのほうとほぼ同じ
    (0...@@player.exp).each do |i|
      Window.draw((@@win_w / 7 - 40).floor + i * @@block_width, @@win_h / 2 - 100, @@exp_block, 50)
    end
    Window.draw_font((@@win_w / 7 - 42).floor, (@@win_h / 2 - 73 - @@font_size * 2), "Level: #{@@player.level} Attak: #{@@player.strength}", @@font, z: 1)
    Window.draw((@@win_w / 7 - 42).floor, @@win_h / 2 - 102, @@exp_bar_background, 20)
  end

  def self.player_view
    Window.draw(@@win_w / 7, @@win_h * 5 / 7 - @@player_img.height, @@player_img, 50)
  end
end

class Home_UI < UI
  def initialize
    # ==================拠点ボタン系==================
    @@home_img = Image.new(64, 64, [200, 150, 100])
    @@shop_img = Image.new(64, 64, [200, 100, 150])
    @@explore_img = Image.new(64, 64, [100, 200, 150])

    @@home_button = [Sprite.new(@@button_left_margin + @@img_margin - @@img_width / 2, @@buttons_y, @@home_img), Sprite.new(@@button_left_margin + @@img_margin - @@img_width / 2, @@buttons_y, @@home_img.flush([50, 50, 50]))]
    @@shop_button = [Sprite.new(@@button_left_margin + @@img_margin * 2 + @@img_width * 0.5, @@buttons_y, @@shop_img), Sprite.new(@@button_left_margin + @@img_margin * 2 + @@img_width * 0.5, @@buttons_y, @@shop_img.flush([50, 50, 50]))]
    @@explore_button = [Sprite.new(@@button_left_margin + @@img_margin * 5 + @@img_width * 3.5, @@buttons_y, @@explore_img), Sprite.new(@@button_left_margin + @@img_margin * 5 + @@img_width * 3.5, @@buttons_y, @@explore_img.flush([50, 50, 50]))]

    @@home_buttons = [@@home_button, @@shop_button, @@explore_button]
    @@home_buttons.each { |bb| bb[0].z = 100 }
 end

  def self.home_menu
    # ここではボタンの表示をしている
    # なので最初にマウスの位置を取得
    @@cursor.x = Input.mouse_pos_x
    @@cursor.y = Input.mouse_pos_y

    Sprite.draw(@@home_buttons)
    # ボタンにマウスオーバーしてるときのみ色が反転する
    # スプライトの配列を作ってそれを表示させている
    # ちなみにここはスキル押してないときのボタン表示
    if i = @@cursor.check(@@home_buttons)[1]
      i.z = 101
      Window.draw(i.x - @@img_width / 4, i.y - @@img_width / 4, @@hover, 1)
      # 一回描写
      Sprite.draw(i)
      i.z = 0
    end
  end

  def self.home_read
    # returnした文字列でプレイヤーのメソッドを呼びます
    # ボタンを追加したらそのreturnも追加しよう
    # もちろんそのプレイヤーのメソッドも
    case @@cursor
    when @@home_button[0]
      return 'home'
    when @@shop_button[0]
      return 'shop'
    when @@explore_button[0]
      return 'explore'
    else
      return false
    end
    false
  end

  def self.home_view; end
end

class Battle_UI < UI
  def initialize
    # ==================バトルボタン系==================
    # ボタンの作り方と説明
    # まずそのボタンの画像を用意します
    # 画像の大きさが他と同じ(今は64ピクセル)じゃないならimage.slice(x, y, width, height)でがんばる
    # 画像自体を編集するほうが楽かも
    # イメージの宣言 @@名前_img
    # それからその画像でスプライトを作る(なぜスプライトにするかというとボタンとして機能するように衝突判定させたいから)
    # スプライト宣言 @@名前_button = Sprite.new(@@img_margin * 左から何個目か+ @@img_width * 左から何個目か引く1,  @@名前_img)
    # 今回はマウスオーバーすると色を変えたいので
    # @@ボタンの名前 = [Sprite.new = (省略),Sprite.new = (左と同じだけど最後の画像を @@名前_img.flush(したい色のrgb))]として
    # 普通の時は@@名前_button[0]を表示するようにしてマウスオーバーしたら@@名前_button[1]を表示するようにすれば変わる(この変更方法についてはほかにも試したけどうまくいかなかった)
    # battle_readというのが結構下にあるから返す行動を指定する
    # もちろんPlayerに対応するメソッドを作るのを忘れずに

    @@attak_img = Image.load('./media/button/attak.png')
    @@defence_img = Image.load('./media/button/defence.png')
    @@skill_img = Image.load('./media/button/skill.png')
    @@fire_img = Image.load('./media/button/fire.png')
    @@ice_img = Image.load('./media/button/ice.png')
    @@escape_img = Image.load('./media/button/escape.png')

    # ボタン置き場
    # 色が変わるやつは配列になってるので注意
    @@attak_button = [Sprite.new(@@button_left_margin + @@img_margin - @@img_width / 2, @@buttons_y, @@attak_img), Sprite.new(@@button_left_margin + @@img_margin - @@img_width / 2, @@buttons_y, @@attak_img.flush([50, 50, 50]))]
    @@defence_button = [Sprite.new(@@button_left_margin + @@img_margin * 2 + @@img_width * 0.5, @@buttons_y, @@defence_img), Sprite.new(@@button_left_margin + @@img_margin * 2 + @@img_width * 0.5, @@buttons_y, @@defence_img.flush([50, 50, 50]))]
    @@skill_button = [Sprite.new(@@button_left_margin + @@img_margin * 3 + @@img_width * 1.5, @@buttons_y, @@skill_img), Sprite.new(@@button_left_margin + @@img_margin * 3 + @@img_width * 1.5, @@buttons_y, @@skill_img.flush([50, 50, 50]))]
    @@test_a_button = [Sprite.new(@@button_left_margin + @@img_margin * 4 + @@img_width * 2.5, @@buttons_y, @@skill_img), Sprite.new(@@button_left_margin + @@img_margin * 4 + @@img_width * 2.5, @@buttons_y, @@skill_img.flush([50, 50, 50]))]
    @@test_b_button = [Sprite.new(@@button_left_margin + @@img_margin * 5 + @@img_width * 3.5, @@buttons_y, @@skill_img), Sprite.new(@@button_left_margin + @@img_margin * 5 + @@img_width * 3.5, @@buttons_y, @@skill_img.flush([50, 50, 50]))]
    @@escape_button = [Sprite.new(@@button_left_margin + @@img_margin * 6 + @@img_width * 4.5, @@buttons_y, @@escape_img), Sprite.new(@@button_left_margin + @@img_margin * 6 + @@img_width * 4.5, @@buttons_y, @@escape_img.flush([50, 50, 50]))]
    # スキルボタン
    @@fire_button = Sprite.new(@@button_left_margin + @@img_margin - @@img_width / 2, @@buttons_y, @@fire_img)
    @@ice_button = Sprite.new(@@button_left_margin + @@img_margin * 2 + @@img_width * 0.5, @@buttons_y, @@ice_img)
    # ボタンのスプライトを配列にまとめとく
    # ボタンを追加したらここに入れないと表示されないよ
    # ちなみに動きはbattle_readでしてるからそっちも編集だ
    # enemy_imgsみたいにまとめたいけどSprite.drawで認識されなくなるからできない.vales関連で頑張ればできるかも
    # でも今のところは普通の配列で不自由ない
    @@battle_buttons = [@@attak_button, @@defence_button, @@skill_button, @@escape_button]
    # @@battle_buttons = [@@attak_button, @@defence_button, @@skill_button, @@test_a_button, @@test_b_button, @@escape_button]
    # スキルボタン押した？flg
    @@skill_flg = 0
    # スキルボタンまとめ
    @@skill_buttons = [@@fire_button, @@ice_button, @@cancel_button]
    # ボタンが背景に埋もれないように zを大きめにする
    @@battle_buttons.each { |bb| bb[0].z = 100 }
    @@fire_button.z = 150
    @@ice_button.z = 150
    @@cancel_button[0].z = 150
  end

  def self.battle_menu
    # ここではボタンの表示をしている
    # なので最初にマウスの位置を取得
    @@cursor.x = Input.mouse_pos_x
    @@cursor.y = Input.mouse_pos_y

    # スキルボタン押されてたら1なので上の処理
    if @@skill_flg == 1
      Sprite.draw(@@skill_buttons)
      # スキルボタンとカーソルの衝突 ちなみに戻ってくるのは 衝突しているスプライトの配列
      k = @@cursor.check(@@skill_buttons)
      # なのでk[1]とかはあまり信用できるとはいえない
      # インクルードで何とかなるかもしれない
      if k[1]
        # マウスオーバーできるボタンは実は色変わった後も常に描写されてるけど奥にあるだけ
        # あまりいいコードに見えないけど他がうまくいかなかった
        # if文をネストにするならいくらでもできそうだけど
        k[1].z = 151
        Window.draw(k[1].x - @@img_width / 4, k[1].y - @@img_width / 4, @@hover, 1)
        Sprite.draw(k[1])
        k[1].z = 0
      elsif k[0]
        Window.draw(k[0].x - @@img_width / 4, k[0].y - @@img_width / 4, @@hover, 1)
      end
    else
      # ボタンにマウスオーバーしてるときのみ色が反転する
      # スプライトの配列を作ってそれを表示させている
      # ちなみにここはスキル押してないときのボタン表示
      if i = @@cursor.check(@@battle_buttons)[1]
        i.z = 101
        Window.draw(i.x - @@img_width / 4, i.y - @@img_width / 4, @@hover, 1)
        # 一回描写
        Sprite.draw(i)
        i.z = 0
      end
      Sprite.draw(@@battle_buttons)
    end
  end

  def self.battle_read
    # returnした文字列でプレイヤーのメソッドを呼びます
    # ボタンを追加したらそのreturnも追加しよう
    # もちろんそのプレイヤーのメソッドも

    # スキル押しました？0=no, 1=yes
    if @@skill_flg == 0
      case @@cursor
      when @@attak_button[0]
        return 'attak'
      when @@defence_button[0]
        return 'defence'
      when @@skill_button[0]
        # スキルボタン押します
        @@skill_flg = 1
      when @@escape_button[0]
        return 'escape'
      else
        return false
      end
    elsif @@skill_flg == 1
      case @@cursor
      when @@fire_button
        # ここに@@skill_flg = 0をかくと一回一回押してない状態に戻る
        # 今はスキル連打するのでしない
        return('fire_breath')
      when @@ice_button
        # @@skill_flg = 0
        return('blizzard')
      when @@cancel_button[0]
        # スキル使うのやめます
        # バトルメニューに戻る
        @@skill_flg = 0
      end
    end
    false
  end

  def self.battle_view(enemy)
    # エネミーが生きているならエンカウントしたエネミーの画像を表示するよ
    # 配列の中にハッシュがあるおかげで名前同士の比較ができるね
    # エネミーが生きているなら エネミーイメージに エネミーイメージスのエネミーの名前に一致したものの画像を入れる
    # セレクトは配列にして返してくるみたいなのでファーストとか忘れずにfindつかってもいいかもね
    if enemy.alive_flg && @@enemy_img = @@enemy_imgs.select { |abc| abc[:name] == enemy.name }.first[:img]
      Window.draw(@@win_w * 5 / 7, @@win_h * 5 / 7 - @@enemy_img.height, @@enemy_img, 50)
    end
    player_view
    exp_bar if @@player.alive_flg
    hp_bar(enemy)
    # puts @@enemy_imgs.select { |abc| abc[:name] == enemy.name }.first
    # puts @@enemy_imgs.first[:name]
    # hash.select{|k, b| k.match(/^name$/)}
  end
end

class Stage_UI < UI
  def initialize
    @@GO_img = Image.load('./media/button/GO.png')
    @@left_arrow = Image.load('./media/button/left_arrow.png')
    @@right_arrow = Image.load('./media/button/right_arrow.png')
    @@white_circle = Image.load('./media/button/circle.png')
    @@black_circle = Image.load('./media/button/circle.png').flush([50, 50, 50])
    @@GO_button = [Sprite.new(@@button_left_margin + @@img_margin * 5 + @@img_width * 3.5, @@buttons_y, @@GO_img), Sprite.new(@@button_left_margin + @@img_margin * 5 + @@img_width * 3.5, @@buttons_y, @@GO_img.flush([50, 50, 50]))]
    @@left_arrow_button = [Sprite.new(@@img_width / 2, (@@win_h - @@img_height) / 2, @@left_arrow), Sprite.new(@@img_width / 2, (@@win_h - @@img_height) / 2, @@left_arrow.flush([50, 50, 50]))]
    @@right_arrow_button = [Sprite.new(@@win_w - @@img_width * 1.5, (@@win_h - @@img_height) / 2, @@right_arrow), Sprite.new(@@win_w - @@img_width * 1.5, (@@win_h - @@img_height) / 2, @@right_arrow.flush([50, 50, 50]))]
    @@arrow_buttons = [@@left_arrow_button, @@right_arrow_button]
    @@stage_buttons = [@@GO_button, @@cancel_button]
    @@stage_buttons.each { |bb| bb[0].z = 100 }
    @@arrow_buttons.each { |bb| bb[0].z = 100 }
    @@stage_list = @@data[:stagelist]
    @@i = 0
  end

  def self.stage_menu
    Sprite.draw(@@stage_buttons)
    if i = @@cursor.check(@@stage_buttons)[1]
      i.z = 101
      Window.draw(i.x - @@img_width / 4, i.y - @@img_width / 4, @@hover, 1)
      # 一回描写
      Sprite.draw(i)
      i.z = 0
    end
  end

  def self.stage_read
    # returnした文字列でプレイヤーのメソッドを呼びます
    # ボタンを追加したらそのreturnも追加しよう
    # もちろんそのプレイヤーのメソッドも
    case @@cursor
    when @@GO_button[0]
      if @@i == 0
        return 'forest'
      elsif @@i == 1
        return 'marine'
      end
    when @@cancel_button[0]
      return 'cancel'
    else
      return false
    end
    false
  end

  def self.stage_arrow
    if @@i >= 1
      Sprite.draw(@@left_arrow_button[0])
      Window.draw(@@img_width / 3, (@@win_h - @@img_height * 1.5) / 2, @@black_circle, 20)
      if i = @@cursor.check(@@left_arrow_button)[1]
        i.z = 101
        Window.draw(@@img_width / 3, (@@win_h - @@img_height * 1.5) / 2, @@white_circle, 30)
        # 一回描写
        Sprite.draw(i)
        i.z = 0
      end
    end
    if @@i < @@stage_list.size - 1
      Sprite.draw(@@right_arrow_button[0])
      Window.draw(@@win_w - @@img_width * 1.80, (@@win_h - @@img_height * 1.5) / 2, @@black_circle, 20)
      if i = @@cursor.check(@@right_arrow_button)[1]
        i.z = 101
        Window.draw(@@win_w - @@img_width * 1.80, (@@win_h - @@img_height * 1.5) / 2, @@white_circle, 30)
        # 一回描写
        Sprite.draw(i)
        i.z = 0
      end
  end
  end

  def self.view
    @@cursor.x = Input.mouse_pos_x
    @@cursor.y = Input.mouse_pos_y
    stage_arrow
    stage_menu
    background(@@stage_list[@@i])
    @@i += 1 if @@i < @@stage_list.size - 1 && (Input.mousePush?(M_LBUTTON) && @@cursor === @@right_arrow_button)
    @@i -= 1 if @@i >= 1 && (Input.mousePush?(M_LBUTTON) && @@cursor === @@left_arrow_button)
  end
end
