class Game_window
  attr_accessor :flg

  def initialize
    data = Game_data.book
    Window.width = data[:win_w]
    Window.height = data[:win_h]

    # ちょっとナンセンスだけど初期の文字
    @str = ["マウスで操作！\nまだ動作だけなので目標などはありません！"]
    # @battle = Battle.new(@ui, enemy_list, player)
    @flg = 0
    @scene = 'title'
  end

  def display
    Window.loop do
      case @scene
      when 'title'
        UI.background('home')
        Texts.text(@str, 3)

        if Input.mousePush?(M_LBUTTON)
          @str = []
          @scene = 'home'
        end
      when 'home'
        UI.background('home')
        Texts.text(@str, 3)
        Home.run

        if Home.select == 'explore'
          @str = []
          @scene = 'stage_slect'
        end
        # ここらへん回りくどいのでホームにまとめたほうがいいかもね
        # ステージ選択も拠点でやってるわけだし
      when 'stage_slect'
        Stage.run
        Texts.text(@str, 3)
        if Stage.select == 'GO'
          Battle.start
          @str = []
          @scene = 'battle'
        elsif Stage.select == 'cancel'
          @scene = 'home'
        end
      when 'battle'
        UI.background('forest')
        @str = Battle.run('式展開とかでどこのステージか入れる今はforest')
        Texts.text(@str, 3)

        if Battle.end == 'lose'
          @str = []
          @scene = 'home'
        end
      end
    end
  end
end
