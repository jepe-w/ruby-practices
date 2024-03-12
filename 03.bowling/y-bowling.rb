#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
split_score = score.split(',')
shots = []

split_score.each do |s|
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

frames[9] += frames.pop if frames.length == 11

point = 0
frames.each_with_index do |frame, i|
  next_frame = frames[i + 1]
  not_last_frame = frame.length == 2
  strilke = frame[0] == 10
  spare = frame.sum == 10

  point += if not_last_frame && strilke
             if next_frame.length == 3
               10 + next_frame[0..1].sum
             elsif next_frame[0] == 10
               10 + 10 + frames[i + 2][0]
             else
               10 + next_frame.sum
             end
           elsif not_last_frame && spare
             frame.sum + next_frame[0]
           else
             frame.sum
           end
end
puts point
