class Timer
  def initialize
    # 基準となる時間を設定
    @start_time = Time.now.tv_sec
  end

  def timer(max = false)
    # 正直この差分いらない気がする
    # maxが入力されてないならずっとカウントアップを続ける
    return (Time.now.tv_sec - @start_time) unless max
    # maxが入力されているならカウントがmaxの値になった瞬間1を返す
    return count(max) if max
  end

  def count(max)
    @flg = 0
    n = Time.now.tv_sec - @start_time
    if n >= max
      @start_time = Time.now.tv_sec
      @flg = 1
    end
    @flg
  end
end
