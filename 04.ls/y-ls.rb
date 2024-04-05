#!/usr/bin/env ruby
# frozen_string_literal: true

def filenames
  Dir.foreach('.').reject { _1.start_with?('.') }.sort
end

max_char_count = filenames.map(&:length).max
sorted_filenames = filenames
ROW_NUM = 3

def output_filenames(row_num, sorted_filenames, max_char_count)
  filenames_length = sorted_filenames.length
  rows_num_to_make = filenames_length.ceildiv(row_num)
  output_arrays = Array.new(rows_num_to_make) { [] }

  sorted_filenames.each_with_index do |v, i|
    rows_num_to_push = i % rows_num_to_make
    output_arrays[rows_num_to_push].push(v.ljust(max_char_count))
  end
  output_arrays.each { puts _1.join('  ') }
end

output_filenames(ROW_NUM, sorted_filenames, max_char_count)
