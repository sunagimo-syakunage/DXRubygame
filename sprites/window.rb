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
          Battle.start
          @str = []
          @scene = 'stage_slect'
        end

      when 'stage_slect'
        Stage.run
        Texts.text(@str, 3)

      when 'battle'
        UI.background('forest')
        @str = Battle.run('式展開とかでどこのステージか入れる今はforest')
        Texts.text(@str, 3)
        @scene = 'home' if Battle.end == 'lose'
      end
    end
  end
end
