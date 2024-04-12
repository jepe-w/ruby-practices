#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def filenames
  option_item = ARGV.getopts('a')
  option_item['a'] ? Dir.foreach('.').sort : Dir.foreach('.').reject { _1.start_with?('.') }.sort
end

def output_filenames(row_length, sorted_filenames)
  max_filename_length = sorted_filenames.map(&:length).max
  column_length = sorted_filenames.length.ceildiv(row_length)
  matrix_to_display = Array.new(column_length) { [] }

  sorted_filenames.each_with_index do |v, i|
    row_index = i % column_length
    matrix_to_display[row_index].push(v.ljust(max_filename_length))
  end
  matrix_to_display.each { puts _1.join('  ') }
end

ROW_LENGTH = 4
output_filenames(ROW_LENGTH, filenames)
