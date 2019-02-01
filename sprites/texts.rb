class Texts
  def initialize
    # timerの初期化
    @@timer = Timer.new
    @@k = 0
  end

  def self.text(str, count = false)
    # 自動送りがあるときはタイマーを動かす
    # if count != 0 にしてデフォルト値をfalseでなくて3とかにするのもいいかも
    i = @@timer.timer(count) if count

    # 左クリックかcountの秒数たったら文章送り
    if Input.mousePush?(M_LBUTTON) && !str.empty?
      @@k += 1
      # 左クリックを押してからまた三秒図る
      @@timer = Timer.new
    elsif i == 1 && !str.empty?
      @@k += 1
    end

    # uiに渡して出力
    # 今は一行だけにしているから適当
    UI.text_field(str, str.size - 1)

    # strの文章の個数を超えるとだめなので@@k=0する
    # でもこの処理は文章がループするとき用だからいるのかな？
    @@k = 0 if str.size <= @@k
  end
end
