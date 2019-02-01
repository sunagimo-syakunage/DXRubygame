class Home
  def initialize
    @@home_menu_flg = 1
    @@select = false
  end

  def home_menu; end

  def home_shop; end

  def self.run
    @@select = false
    Home_UI.home_menu if @@home_menu_flg == 1
    @@select = Home_UI.home_read if Input.mousePush?(M_LBUTTON)
  end

  def self.select
    @@select
  end
end
