#!/usr/bin/env ruby
require "date"
require "optparse"

def create_calendar
  opt = OptionParser.new
  target_year = Date.today.year
  target_month = Date.today.mon
  option = {}

  opt.on('-y Integer') { 
    |y| option[:y] = y
    target_year = option[:y]
  }
  opt.on('-m Integer') { 
    |m| option[:m] = m
    target_month = option[:m]}
  opt.parse!(ARGV)
  
  first_day = Date.new(target_year.to_i, target_month.to_i, 1)
  month_day = Date.new(target_year.to_i, target_month.to_i, -1).day
  day_of_week = first_day.wday
  
  #曜日ぶんから文字を挿入（初日のスタート位置（曜日）をとるため）
  days = []
  day_of_week.times do
    days.push("  ")
  end
  #その月の日数分daysに日にちを追加
  1.upto(month_day) do |d|
    if d < 10
      days.push(" #{d}")
    else
      days.push(d)
    end
  end

  week = days.each_slice(7).to_a
  puts first_day.strftime("%B %Y").center(20)
  puts ("日 月 火 水 木 金 土")
  week.each{ |day| puts day.join(" ") }
end

create_calendar
