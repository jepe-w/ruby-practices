#!/usr/bin/env ruby
# frozen_string_literal: true

def title_chars_count
  Dir.foreach('.').reject { /\A\..*/.match?(_1) }.map(&:length)
end

word_count = title_chars_count
max_char_number = word_count.max

def directories_and_filles_get(max_char_number)
  Dir.foreach('.').reject { /\A\..*/.match?(_1) }.map { _1.ljust(max_char_number) }
end

element_count_number = directories_and_filles_get(max_char_number).length
sort_directories_and_folder_list = directories_and_filles_get(max_char_number).sort

def output_directories(row_num, sort_directories_and_folder_list, element_count_number)
  _, surplus_num = element_count_number.divmod(row_num)
  exact_num = surplus_num + 1 unless surplus_num.zero?
  output_arrays = Array.new(exact_num) { [] }

  sort_directories_and_folder_list.each_with_index do |v, i|
    _, exact_num_count = i.divmod(exact_num)

    output_arrays[exact_num_count].push(v)
  end
  output_arrays.each { |item| puts item.join('  ') }
end

def output_directories_one_row(sort_directories_and_folder_list)
  output_arrays = []

  sort_directories_and_folder_list.each { |item| output_arrays.push(item) }
  puts output_arrays.join('  ')
end

ROW_NUM = 3

output_directories_one_row(sort_directories_and_folder_list) if word_count.length < ROW_NUM
output_directories(ROW_NUM, sort_directories_and_folder_list, element_count_number) unless word_count.length < ROW_NUM
