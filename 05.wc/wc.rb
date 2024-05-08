#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

def main
  options = ARGV.getopts('lwc')
  filenames = ARGV

  if filenames.any?
    file_details = filenames.map { |file| File.read(file) }
    words_width = file_details.map { |detail| detail.bytesize.to_s }.max.length
    display_values(filenames, file_details, options, words_width)
    display_totals(file_details, options, words_width) if filenames.length > 1
  else
    display_inputted_values(options)
  end
end

def display_inputted_values(options)
  words_width = 7
  gets_inputted_values = readlines
  input_values = gets_inputted_values.join('')

  option_values = obtained_option_value(input_values, options, words_width)
  puts option_values.join(' ')
end

def display_values(filenames, file_details, options, words_width)
  matrix_to_display = Array.new(file_details.length) { [] }
  file_details.map.with_index do |file_detail, i|
    option_values = obtained_option_value(file_detail, options, words_width)
    if filenames.length > 1
      rjust_result_of_option = option_values.map { |value| value.rjust(words_width) }
      matrix_to_display[i].push(rjust_result_of_option.push(filenames[i]))
    else
      matrix_to_display[i].push(option_values.push(filenames[i]))
    end
  end
  matrix_to_display.each { |display| puts display.join(' ') }
end

def obtained_option_value(files, options, words_width)
  chars = files.bytesize.to_s
  lines = files.lines.length.to_s
  words = files.split.count.to_s
  use_option = options.select { |_key, value| value }.keys
  options_hash = {}
  use_option.each do |option|
    case option
    when 'l' then options_hash['l'] = lines
    when 'w' then options_hash['w'] = words
    when 'c' then options_hash['c'] = chars
    end
  end
  if use_option.empty?
    use_option = %w[l w c]
    options_hash = { 'l' => lines, 'w' => words, 'c' => chars }
  end
  options_hash.length > 1 ? use_option.map { |option| options_hash[option].rjust(words_width) } : [options_hash[use_option[0]]]
end

def display_totals(file_details, options, words_width)
  options_hash = { 'l' => 0, 'w' => 0, 'c' => 0 }
  file_details.each do |detail|
    options_hash['l'] += detail.lines.length
    options_hash['w'] += detail.split.count
    options_hash['c'] += detail.bytesize
  end
  use_option = options.select { |_key, value| value }.keys
  use_option = %w[l w c] if use_option.empty?
  display_total_values = use_option.map { |option| options_hash[option].to_s.rjust(words_width) } if file_details.length > 1
  puts display_total_values.push('total').join(' ')
end

main
