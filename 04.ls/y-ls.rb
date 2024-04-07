#!/usr/bin/env ruby
# frozen_string_literal: true

def filenames
  Dir.foreach('.').reject { _1.start_with?('.') }.sort
end

max_char_num = filenames.map(&:length).max
ROW_NUM = 3

def output_filenames(row_num, filenames, max_char_num)
  column_num = filenames.length.ceildiv(row_num)
  matrix_to_display = Array.new(column_num) { [] }

  filenames.each_with_index do |v, i|
    rows_push_num = i % column_num
    matrix_to_display[rows_push_num].push(v.ljust(max_char_num))
  end
  matrix_to_display.each { puts _1.join('  ') }
end

output_filenames(ROW_NUM, filenames, max_char_num)
