#!/usr/bin/env ruby
# frozen_string_literal: true

def title_chars_count
  Dir.foreach('.').reject { /\A\..*/.match?(_1) }.map(&:length)
end

word_count = title_chars_count
max_char_number = word_count.max

def contents_get(max_char_number)
  Dir.foreach('.').reject { /\A\..*/.match?(_1) }.map { _1.ljust(max_char_number) }
end

element_count_number = contents_get(max_char_number).length
sort_contents = contents_get(max_char_number).sort

def output_directories(row_num, sort_contents, element_count_number)
  if element_count_number < ROW_NUM
    puts sort_contents.join('  ')
  else
    surplus_num = element_count_number % row_num
    rows_num_to_make = surplus_num + 1 unless surplus_num.zero?
    output_arrays = Array.new(rows_num_to_make) { [] }
    sort_contents.each_with_index do |v, i|
      rows_num_to_push = i % rows_num_to_make

      output_arrays[rows_num_to_push].push(v)
    end
    output_arrays.each { |item| puts item.join('  ') }
  end
end

ROW_NUM = 3

output_directories(ROW_NUM, sort_contents, element_count_number)
