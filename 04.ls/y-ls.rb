#!/usr/bin/env ruby
# frozen_string_literal: true

def contents_checker
  Dir.foreach('.').reject { _1.start_with?('.') }
end

title_chars_count = contents_checker.map { |item| item.encode('EUC-JP').bytesize }
max_char_number = title_chars_count.max
contents_get = contents_checker.map do |item|
  brunk_char_number = max_char_number - item.encode('EUC-JP').bytesize
  item + ' ' * brunk_char_number
end
element_count_number = contents_get.length
sort_contents = contents_get.sort
ROW_NUM = 3

def output_directories(row_num, sort_contents, element_count_number)
  if element_count_number <= row_num
    puts sort_contents.join('  ')
  else
    column_num, surplus_num = element_count_number.divmod(row_num)
    rows_num_to_make = column_num + 1 unless surplus_num.zero?
    output_arrays = Array.new(rows_num_to_make) { [] }

    sort_contents.each_with_index do |v, i|
      rows_num_to_push = i % rows_num_to_make
      output_arrays[rows_num_to_push].push(v)
    end

    output_arrays.each { |item| puts item.join('  ') }
  end
end

output_directories(ROW_NUM, sort_contents, element_count_number)
