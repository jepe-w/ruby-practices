#!/usr/bin/env ruby

score = ARGV[0]
score = score.split(',')
shots = []

score.each do |s|
  #最後の一回は１０を一回分ずつ追加
  if shots.length < 18
    if s == 'x'
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end

  else
    if s == 'x'
      shots << 10
    else
      shots << s.to_i
    end

  end

end

#最後の10回目は場合によっては３回になる
frames = []
shots.each_slice(2) do |s|
  frames << s
end
#２回ずつで分けて最後に一つ残った場合は１０回目に追加する
if frames.length == 11
  frames[9] += frames[10]
  frames.pop
end


point = 0
count = 0
 #ストライクの場合は次のframeの合計を加算
 #スペアの場合は次のframeの一回目の点数を加算
frames.each do |frame|
  if frame.length == 2
    if frame[0] == 10
      point += frame.sum + frames[count + 1][0] + frames[count + 1][1]
    elsif frame.sum == 10 
      point += frame.sum + frames[count + 1][0]
    else
    point += frame.sum
    end

  else
    point += frame.sum
  end
  count += 1
end


p point