class Stage
  def initialize
    @@stage_list = Data[:stagelist]
    @@select = false
  end

  def self.run
    Stage_UI.view
    @@select = false
    @@select = Stage_UI.stage_read if Input.mousePush?(M_LBUTTON)
  end

  def self.select
    @@select
  end
end
