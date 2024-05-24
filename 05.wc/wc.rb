#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  if options.values.uniq.length == 1
    options = options.each_key do |key|
      options[key] = true
    end
  end
  filenames = ARGV

  if filenames.any?
    handle_multiple_files(filenames, options)
  else
    inputted_values = readlines
    input_text = inputted_values.join('')
    handle_standard_input(input_text, options)
  end
end

def handle_standard_input(input_text, options)
  detail_hash = create_detail_hash(input_text)
  display_values([detail_hash], options)
end

def handle_multiple_files(files, options)
  file_texts = files.map do |file|
    File.read(file)
  end
  if files.length >= 2
    file_texts.push(file_texts.join(''))
    files.push('total')
  end
  detail_hash = file_texts.map.with_index do |file_text, index|
    create_detail_hash(file_text, files[index])
  end
  words_width = create_words_width(detail_hash, options)
  display_values(detail_hash, options, words_width)
end

def create_words_width(detail_hash, options)
  numbers_hash = detail_hash.map do |hash|
    hash.reject do |key, _value|
      key == 'name'
    end
  end

  if detail_hash.length <= 1 && options.count do |_key, value|
    value == true
  end <= 1
    0
  else
    numbers_hash.map do |number|
      number.values.max
    end.max.to_s.length
  end
end

def create_detail_hash(text, filename = 'default')
  {
    'name' => filename,
    'c' => text.bytesize,
    'l' => text.lines.length,
    'w' => text.split.count
  }
end

def display_values(file_details, options, words_width = 0)
  file_details.each do |file_detail|
    columns = []
    columns << file_detail['l'].to_s.rjust(words_width) if options['l']
    columns << file_detail['w'].to_s.rjust(words_width) if options['w']
    columns << file_detail['c'].to_s.rjust(words_width) if options['c']
    columns << file_detail['name'] if file_detail['name'] != 'default'
    puts columns.join(' ')
  end
end

main
