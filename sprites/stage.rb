class Stage
  def initialize
    @@stage_list = Data[:stagelist]
  end

  def self.run
    Stage_UI.view
  end
end
