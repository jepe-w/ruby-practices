#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  options.transform_values! { true } if options.values.all? { |value| value == false }
  filenames = ARGV

  if filenames.any?
    handle_multiple_files(filenames, options)
  else
    text = readlines.join('')
    handle_standard_input(text, options)
  end
end

def handle_standard_input(text, options)
  detail_hashes = create_detail_hash(text)
  display_values([detail_hashes], options)
end

def handle_multiple_files(files, options)
  detail_hashes = files.map do |file|
    text = File.read(file)
    detail = create_detail_hash(text)
    detail['name'] = file
    detail
  end
  if files.length >= 2
    total = { 'name' => 'total' }
    options.each_key do |option|
      total[option.to_s] = detail_hashes.inject(0) do |sum, hash|
        sum + hash[option.to_s]
      end
    end
    detail_hashes << total
  end
  words_width = create_words_width(detail_hashes, options)
  display_values(detail_hashes, options, words_width)
end

def create_words_width(detail_hashes, options)
  numbers_hash = detail_hashes.map do |hash|
    hash.reject do |key, _value|
      key == 'name'
    end
  end

  if detail_hashes.length <= 1 && options.count do |_key, value|
    value == true
  end <= 1
    0
  else
    numbers_hash.map do |number|
      number.values.max
    end.max.to_s.length
  end
end

def create_detail_hash(text, filename = '')
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
    columns << file_detail['name'] if file_detail['name'] != ''
    puts columns.join(' ')
  end
end

main
