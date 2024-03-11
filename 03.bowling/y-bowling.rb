#!/usr/bin/env ruby
# frozen_string_literal: true


score = ARGV[0]
score = score.split(',')
shots = []

score.each do |s|
  if shots.length < 18
    if s == 'X'
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  else
    shots << if s == 'X'
               10
             else
               s.to_i
             end
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

if frames.length == 11
  frames[9] += frames[10]
  frames.pop
end

point = 0
count = 0
frames.each do |frame|
  point += if frame.length == 2 && frame[0] == 10
             if frames[count + 1].length == 3
               10 + frames[count + 1][0] + frames[count + 1][1]
             elsif frames[count + 1][0] == 10
               10 + 10 + frames[count + 2][0]
             else
               10 + frames[count + 1][0] + frames[count + 1][1]
             end
           elsif frame.length == 2 && frame.sum == 10
             frame.sum + frames[count + 1][0]
           else
             frame.sum
           end
  count += 1
end
puts point
