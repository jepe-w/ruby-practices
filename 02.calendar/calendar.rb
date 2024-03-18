#!/usr/bin/env ruby
require "date"
require "optparse"

def create_calendar
  opt = OptionParser.new
  target_year = Date.today.year
  target_month = Date.today.mon
  option = {}

  opt.on('-y Integer') do |y| 
    target_year = y
  end

  opt.on('-m Integer') do |m| 
    target_month = m
  end
  opt.parse!(ARGV)
  
  first_date = Date.new(target_year.to_i, target_month.to_i, 1)
  last_date = Date.new(target_year.to_i, target_month.to_i, -1)
  day_of_week = first_date.wday
  
  days = []
  day_of_week.times do
    days.push("  ")
  end

  1.upto(last_date.day) do |d|
    is_single_digit_date = d < 10
    if is_single_digit_date
      days.push(" #{d}")
    else
      days.push(d)
    end
  end

  week = days.each_slice(7).to_a
  puts first_date.strftime("%B %Y").center(20)
  puts ("日 月 火 水 木 金 土")
  week.each{ |day| puts day.join(" ") }
end

create_calendar
