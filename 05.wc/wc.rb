#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  filenames = ARGV
  use_opts = options.select { |_key, value| value }.empty? ? %w[l w c] : options.select { |_key, value| value }.keys
  if filenames.any?
    display_values(filenames, use_opts)
  else
    display_inputted_values(use_opts)
  end
end

def create_detail_hashes(files)
  files.map.with_index do |file, i|
    file = File.read(file) if files.length > 1
    {
      'name' => files[i],
      'c' => file.bytesize.to_s,
      'l' => file.lines.length.to_s,
      'w' => file.split.count.to_s
    }
  end
end

def matrix_values(detail_hash, use_opts, words_width)
  if use_opts.length > 1
    detail_hash.map { |hash| use_opts.map { |option| hash[option.to_s].rjust(words_width) }.push(hash['name']) }
  else
    detail_hash.map { |hash| "#{hash[use_opts[0].to_s]} #{hash[0]}" }
  end
end

def values(detail_hash, use_opts, words_width)
  if use_opts.length > 1
    use_opts.map { |option| detail_hash[0][option.to_s].rjust(words_width) }
  else
    use_opts.map { |option| detail_hash[0][option.to_s] }
  end
end

def display_totals(file_details, use_opts, words_width)
  value_hash = { 'l' => 0, 'w' => 0, 'c' => 0 }
  file_details.each do |detail|
    value_hash['l'] += detail.lines.length
    value_hash['w'] += detail.split.count
    value_hash['c'] += detail.bytesize
  end
  total_values = use_opts.length > 1 ? use_opts.map { |option| value_hash[option].to_s.rjust(words_width) } : use_opts.map { |option| value_hash[option] }
  puts total_values.push('total').join(' ')
end

def display_files_values(filenames, use_opts)
  file_details = filenames.map { |file| File.read(file) }
  words_width = file_details.map(&:bytesize).max.to_s.length
  detail_hash = create_detail_hash(filenames)
  values = matrix_values(detail_hash, use_opts, words_width)
  use_opts.length > 1 ? values.each { |item| puts item.join(' ') } : values.each { |item| puts item }
  display_totals(file_details, use_opts, words_width) if filenames.length > 1
end

def display_inputted_values(use_opts)
  words_width = 7
  gets_inputted_values = readlines
  files = [gets_inputted_values.join('')]
  detail_hash = create_detail_hash(files)
  display_values = values(detail_hash, use_opts, words_width)
  puts display_values.join(' ')
end

main
