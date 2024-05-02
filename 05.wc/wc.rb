#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  filename = ARGV
  option_values = { 'l' => 0, 'w' => 0, 'c' => 0 }

  if !filename.empty?
    file_read = filename.map { |file| File.read(file) }
    words_width = file_read.map { |file_detail| file_detail.bytesize.to_s }.max.length
    display_values(filename, file_read, options, words_width)
    display_totals(option_values, file_read, options, words_width) if filename.length > 1
  else
    standard_input(options)
  end
end

def standard_input(options)
  words_width = 7
  gets_file = readlines
  gets_file = gets_file.join('')

  result_of_option = result_of_options(gets_file, options, words_width)
  puts result_of_option.join(' ')
end

def display_values(filename, file_read, options, words_width)
  matrix_to_display = Array.new(file_read.length) { [] }
  file_read.map.with_index do |file_detail, i|
    result_of_option = result_of_options(file_detail, options, words_width)
    if filename.length > 1
      rjust_result_of_option = result_of_option.map { |value| value.rjust(words_width) }
      matrix_to_display[i].push(rjust_result_of_option.push(filename[i]))
    else
      matrix_to_display[i].push(result_of_option.push(filename[i]))
    end
  end
  matrix_to_display.each { |display| puts display.join(' ') }
end

def result_of_options(files, options, words_width)
  chars_in_file = files.bytesize.to_s
  lines_in_file = files.lines.length.to_s
  words_in_file = files.split.count.to_s
  option_values = { 'l' => lines_in_file, 'w' => words_in_file, 'c' => chars_in_file }
  option_select = options.select { |_key, value| value }
  use_option = option_select.empty? ? %w[l w c] : option_select.map { |option| option[0] }
  use_option.length != 1 ? use_option.map { |option| option_values[option].rjust(words_width) } : [option_values[use_option[0]]]
end

def display_totals(option_values, file_read, options, words_width)
  file_read.map do |file|
    option_values['l'] += file.lines.length
    option_values['w'] += file.split.count
    option_values['c'] += file.bytesize
  end
  option_select = options.select { |_key, value| value }
  use_option = option_select.empty? ? %w[l w c] : option_select.map { |option| option[0] }
  display_total_values = use_option.map { |option| option_values[option].to_s.rjust(words_width) } if file_read.length > 1

  puts display_total_values.push('total').join(' ')
end

main
