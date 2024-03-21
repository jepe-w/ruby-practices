#!/usr/bin/env ruby
# frozen_string_literal: true

class ListSegments

  ROW_NUM = 3

  def initialize
    word_count = []
    Dir.foreach('.') do |item|
      next if item == '.' || item =~ /^\..*/
  
      word_count.push(item.length)
    end
    @word_count_list = word_count
    @max_char_number = word_count.max

    directories_and_folder_list = []
    Dir.foreach('.') do |item|
      next if item == '.' || item =~ /^\..*/
  
      number_of_blank = @max_char_number - item.length
      blank = ' ' * number_of_blank
      output_title = item + blank
      directories_and_folder_list.push(output_title)
    end
    @element_count_number = directories_and_folder_list.length
    @sort_directories_and_folder_list = directories_and_folder_list.sort
    @float_elms = @element_count_number.to_f
  end
 
  def output_directories(row_num, output_arrays)
    exact_num = (@float_elms / row_num).ceil
    surplus_num = @element_count_number % row_num
    column_num = @element_count_number / row_num
  
    exact_num.times do
      output_arrays.push([])
    end
  
    @sort_directories_and_folder_list.each_with_index do |v, i|
      exact_num_count = i % exact_num
      column_num_count = i % column_num
  
      if surplus_num.zero?
        output_arrays[column_num_count].push(v)
      else
        output_arrays[exact_num_count].push(v)
      end
    end
    output_arrays.each { |item| puts item.join('  ') }
  end
  
  def output_directories_one_row(output_arrays)

    @sort_directories_and_folder_list.each { |item| output_arrays.push(item) }
    puts output_arrays.join('  ')
  end

  def run
    output_arrays = []
    if @word_count_list.length < ROW_NUM
      output_directories_one_row(output_arrays)
    else
      output_directories(ROW_NUM, output_arrays)
    end
  end
end

ListSegments.new.run
