#!/usr/bin/env ruby
# frozen_string_literal: true

def title_chars_count
  word_count = []
  Dir.foreach('.') do |item|
    next if /\A\..*/.match?(item)

    word_count.push(item.length)
  end
  word_count
end

word_count = title_chars_count
max_char_number = word_count.max

def directories_and_filles_get(max_char_number)
  directories_and_folder_list = []
  Dir.foreach('.') do |item|
    next if /\A\..*/.match?(item)

    output_title = item.ljust(max_char_number)
    directories_and_folder_list.push(output_title)
  end
  directories_and_folder_list
end

element_count_number = directories_and_filles_get(max_char_number).length
sort_directories_and_folder_list = directories_and_filles_get(max_char_number).sort

def output_directories(row_num, sort_directories_and_folder_list, element_count_number)
  output_arrays = []
  acolumn_and_surplus_num = element_count_number.divmod(row_num)
  surplus_num = acolumn_and_surplus_num[1]
  column_num = acolumn_and_surplus_num[0]
  exact_num = surplus_num + 1 unless acolumn_and_surplus_num[1].zero?

  exact_num.times do
    output_arrays.push([])
  end

  sort_directories_and_folder_list.each_with_index do |v, i|
    exact_num_count = i % exact_num
    column_num_count = i % column_num

    next output_arrays[column_num_count].push(v) if surplus_num.zero?

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
