#!/usr/bin/env ruby
# frozen_string_literal: true

def filenames
  Dir.foreach('.').reject { _1.start_with?('.') }.sort
end

def output_filenames(row_length, filenames)
  max_filename_length = filenames.map(&:length).max
  column_length = filenames.length.ceildiv(row_length)
  matrix_to_display = Array.new(column_length) { [] }
  
  filenames.each_with_index do |v, i|
    row_index = i % column_length
    matrix_to_display[row_index].push(v.ljust(max_filename_length))
  end
  matrix_to_display.each { puts _1.join('  ') }
end

ROW_LENGTH = 3
output_filenames(ROW_LENGTH, filenames)
