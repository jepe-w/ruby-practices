#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  filenames = ARGV
  use_opts = options.select { |_key, value| value }.keys
  use_opts = %w[l w c] if use_opts.empty?

  if filenames.any?
    display_values = display_files_values(filenames, use_opts)
    display_values.each { |value| use_opts.length >= 2 ? (puts value.join(' ')) : (puts value) }
  else
    gets_inputted_values = readlines
    input_text = gets_inputted_values.join('')
    display_values = display_files_values(input_text, use_opts)
    puts display_values.join(' ')
  end
end

def display_files_values(files, use_opts)
  if files.instance_of?(String)
    handle_standard_input(files, use_opts)
  else
    handle_multiple_files(files, use_opts)
  end
end

def handle_standard_input(files, use_opts)
  file_details = files
  detail_hash = create_detail_hash(file_details, 'input')
  create_display_values(detail_hash, use_opts)
end

def handle_multiple_files(files, use_opts)
  file_details = files.map { |file| File.read(file) }
  if files.length >= 2
    file_details.push(file_details.join(''))
    files.push('total')
  end
  detail_hash = file_details.map.with_index { |filedetail, index| create_detail_hash(filedetail, files[index]) }
  words_width = detail_hash.map { |hash| hash.select { |_key, value| value.instance_of?(Integer) }.values.max }.max.to_s.length
  words_width = 0 if detail_hash.length <= 1 && use_opts.length <= 1
  create_display_values(detail_hash, use_opts, words_width)
end

def create_detail_hash(filedetails, filename)
  {
    'name' => filename,
    'c' => filedetails.bytesize,
    'l' => filedetails.lines.length,
    'w' => filedetails.split.count
  }
end

def create_display_values(detail_hash, use_opts, words_width = 0)
  standard_input_data = detail_hash.instance_of?(Hash)
  if standard_input_data
    use_opts.map { |option| detail_hash[option.to_s] }
  elsif use_opts.length >= 2
    detail_hash.map { |hash| use_opts.map { |option| hash[option.to_s].to_s.rjust(words_width) }.push(hash['name']) }
  else
    detail_hash.map { |hash| "#{hash[use_opts[0].to_s].to_s.rjust(words_width)} #{hash['name']}" }
  end
end

main
