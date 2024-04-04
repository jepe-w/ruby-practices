#!/usr/bin/env ruby
# frozen_string_literal: true

def filenames
  Dir.foreach('.').reject { _1.start_with?('.') }
end

title_chars_count = filenames.map(&:length)
max_char_count = title_chars_count.max
filename_processed_for_output = filenames.map { _1.ljust(max_char_count) }
element_count = filename_processed_for_output.length
sort_filename = filename_processed_for_output.sort
ROW_NUM = 3

def output_directories(row_num, sort_filename, element_count)
  if element_count <= row_num
    puts sort_filename.join('  ')
  else
    rows_num_to_make, surplus_num = element_count.divmod(row_num)
    rows_num_to_make += 1 unless surplus_num.zero?
    output_arrays = Array.new(rows_num_to_make) { [] }

    sort_filename.each_with_index do |v, i|
      rows_num_to_push = i % rows_num_to_make
      output_arrays[rows_num_to_push].push(v)
    end

    output_arrays.each { |item| puts item.join('  ') }
  end
end

output_directories(ROW_NUM, sort_filename, element_count)
