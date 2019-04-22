class Game_window
  attr_accessor :flg

  def initialize
    @data = Game_data.book
    Window.width = @data[:win_w]
    Window.height = @data[:win_h]

    # ちょっとナンセンスだけど初期の文字
    @str = ["マウスで操作！\nまだ動作だけなので目標などはありません！\n大きなバッテンはダミーボタンなので動きません"]
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
        Stage_UI.view
        Texts.text(@str, 3)
        @stage_select = Stage_UI.stage_read if Input.mousePush?(M_LBUTTON)
        if @stage_select == 'cancel'
          @stage_select = false
          @scene = 'home'
        elsif @stage_select
          Battle.start(@stage_select.name)
          @str = []
          @scene = 'battle'
        end
      when 'battle'
        UI.background(@stage_select.name)
        @str = Battle.run
        Texts.text(@str, 3)

        if Battle.end == 'lose'
          @str = []
          @stage_select = false
          @scene = 'home'
        elsif Battle.end == 'win'
          Battle.start(@stage_select.name)
          @stage_select.stage_exp += 1 if @stage_select.stage_exp < @stage_select.stage_exp_max
        elsif Battle.end == 'escape'
          Battle.start(@stage_select.name)
        end
      end
    end
  end
end
