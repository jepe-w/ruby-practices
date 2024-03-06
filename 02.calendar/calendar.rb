#!/usr/bin/env ruby
require "date"
require "optparse"
require 'debug'

class Clendar
  def initialize()
    opt = OptionParser.new

    opt.on('-y') 
    opt.on('-m') 
    opt.parse!(ARGV)
    ARGV
  end
  
  def create_calendar
    if ARGV == []
      target_year = Date.today.year
    else
      target_year = ARGV[0]
    end
    
    if ARGV == []
      target_month = Date.today.mon
    else
      target_month = ARGV[1]
    end
    
    first_day_of_designated_date = Date.new(target_year.to_i, target_month.to_i, 1)
    month_days = Date.new(target_year.to_i, target_month.to_i, -1).day
    get_day_of_week = first_day_of_designated_date.wday
    
    #曜日ぶんから文字を挿入（初日のスタート位置（曜日）をとるため）
    days = []
    get_day_of_week.times do
      days.push("  ")
    end
    #その月の日数分daysに日にちを追加
    month_days.times do |n|
      n += 1
      if n < 10
        days.push(" #{n}")
      else
        days.push(n)
      end
    end

    week = days.each_slice(7).to_a
    puts first_day_of_designated_date.strftime("%B %Y").center(20)
    puts ("日 月 火 水 木 金 土")
    week.each{|day| puts day.join(" ")}
  end
end

result_calendar = Clendar.new
result_calendar.create_calendar
