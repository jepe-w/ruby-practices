#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
shots = []

scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)
  shots << 0 if shots.length < 18 && s == 'X'
end

frames = shots.each_slice(2).to_a

frames[9] += frames.pop if frames.length == 11
point = frames.each_with_index.sum do |frame, i|
  next_frame = frames[i + 1]
  not_last_frame = i != 9
  strilke = frame[0] == 10
  spare = frame.sum == 10

  if not_last_frame && strilke
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
