#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

option = ARGV.getopts('lwc')
filename = ARGV

def input_pattern(option)
  words_width = 7
  gets_file = readlines
  gets_file = gets_file.join('')
  chars_in_file = gets_file.bytesize.to_s
  lines_in_file = gets_file.lines.length.to_s
  words_in_file = gets_file.split.count.to_s
  option_values = { 'c' => chars_in_file, 'l' => lines_in_file, 'w' => words_in_file }
  option_select = option.select { _2 == true }
  use_option = option_select.empty? ? %w[l w c] : option_select.map { _1[0] }
  display_value = use_option.length != 1 ? use_option.map { |item| option_values[item].rjust(words_width) } : [option_values[use_option[0]]]
  puts display_value.join(' ')
end

def display_values(filename, file_read, option, words_width)
  matrix_to_display = Array.new(file_read.length) { [] }
  file_read.map.with_index do |item, i|
    chars_in_file = item.bytesize.to_s
    lines_in_file = item.lines.length.to_s
    words_in_file = item.split.count.to_s
    option_values = { 'c' => chars_in_file, 'l' => lines_in_file, 'w' => words_in_file }
    option_select = option.select { _2 == true }
    use_option = option_select.empty? ? %w[l w c] : option_select.map { _1[0] }
    display_value = use_option.length != 1 ? use_option.map { |item| option_values[item].rjust(words_width) } : [option_values[use_option[0]]]
    display_value.map! { _1.rjust(words_width) } if filename.length > 1
    matrix_to_display[i].push(display_value.push(filename[i]))
  end
  matrix_to_display.each { puts _1.join(' ') }
end

def display_totals(file_read, option, words_width)
  total_l = 0
  total_w = 0
  total_c = 0
  file_read.map do |item|
    total_l += item.lines.length
    total_w += item.split.count
    total_c += item.bytesize
  end
  option_values = { 'l' => total_l, 'w' => total_w, 'c' => total_c }
  option_select = option.select { _2 == true }
  use_option = option_select.empty? ? %w[l w c] : option_select.map { _1[0] }
  display_total_values = use_option.map { |item| option_values[item].to_s.rjust(words_width) } if file_read.length > 1
  puts display_total_values.push('total').join(' ')
end

if !filename.empty?
  file_read = filename.map { File.read(_1) }
  words_width = file_read.map { _1.bytesize.to_s }.max.length

  display_values(filename, file_read, option, words_width)
  display_totals(file_read, option, words_width) if filename.length > 1
else
  input_pattern(option)
end
