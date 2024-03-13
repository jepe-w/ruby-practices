#!/usr/bin/env ruby
# frozen_string_literal: true

@word_count = []
def title_chars_count
  Dir.foreach('.') do |item|
    next if item == '.' || item =~ /^\..*/

    @word_count.push(item.length)
  end
  @max_char_number = @word_count.max
end

@directories_and_folder_list = []
def dhirectories_and_filles_get
  Dir.foreach('.') do |item|
    next if item == '.' || item =~ /^\..*/

    number_of_blank = @max_char_number - item.length
    blank = ' ' * number_of_blank
    output_title = item + blank
    @directories_and_folder_list.push(output_title)
  end
  @element_count_number = @directories_and_folder_list.length
  @sort_directories_and_folder_list = @directories_and_folder_list.sort
  @float_elms = @element_count_number.to_f
end

@output_arrays = []
def output_dhirectories(row_num)
  title_chars_count
  dhirectories_and_filles_get

  exact_num = (@float_elms / row_num).ceil
  surplus_num = @element_count_number % row_num
  column_num = @element_count_number / row_num

  exact_num.times do
    @output_arrays.push([])
  end

  @sort_directories_and_folder_list.each_with_index do |v, i|
    exact_num_count = i % exact_num
    column_num_count = i % column_num

    if surplus_num.zero?
      @output_arrays[column_num_count].push(v)
    else
      @output_arrays[exact_num_count].push(v)
    end
  end
  @output_arrays.each { |item| puts item.join('  ') }
end

def output_dhirectories_one_row
  title_chars_count
  dhirectories_and_filles_get

  @directories_and_folder_list.each { |item| @output_arrays.push(item) }
  puts @output_arrays.join('  ')
end

row_num = 3
title_chars_count
if @word_count.length < row_num
  output_dhirectories_one_row
else
  output_dhirectories(row_num)
end
