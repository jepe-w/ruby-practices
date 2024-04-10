#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def option
  ARGV.getopts('a')
end

def filenames(option_item)
  if option_item['a']
    Dir.foreach('.').sort_by { |item| item.downcase.delete('.') }
  else
    Dir.foreach('.').reject { _1.start_with?('.') }.sort_by { |item| item.downcase.delete('.') }
  end
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

option_item = option
sorted_filenames = filenames(option_item)
ROW_LENGTH = 3

output_filenames(ROW_LENGTH, sorted_filenames)
