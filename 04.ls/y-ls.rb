#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'time'
require 'etc'

def option_item
  ARGV.getopts('arl')
end
options = option_item

def filenames(options)
  target_filenames = Dir.entries('.')
  target_filenames.reject! { _1.start_with?('.') } unless options['a']
  target_filenames.sort!
  target_filenames.reverse! if options['r']
  target_filenames
end
sorted_filenames = filenames(options)

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

def file_permissions(sorted_filenames)
  filetypes = { '20' => 'c', '40' => 'd', '60' => 'b', '100' => '-', '120' => 'l', '140' => 's' }
  permissiontype = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--r', '0' => '---' }

  sorted_filenames.map do |filename|
    file = File.stat(filename)
    permission = file.mode.to_s(8)
    split_permission = permission[-3..].split('')
    split_permission.map.with_index do |item, i|
      split_permission[i] = permissiontype[item]
    end
    filetypes[permission[..-4]] + split_permission[0] + split_permission[1] + split_permission[2]
  end
end
permissions = file_permissions(sorted_filenames)

def output_file_details(sorted_filenames, permissions)
  block = 0
  file_detail = sorted_filenames.map { |filename| File.stat(filename) }
  links_width = file_detail.map { |item| item.nlink.to_s.length }.max
  file_size_width = file_detail.map { |item| item.size.to_s.length }.max
  user_name_width = file_detail.map { |item| Etc.getpwuid(item.uid).name.length }.max
  groupe_name_width = file_detail.map { |item| Etc.getgrgid(item.gid).name.length }.max
  matrix_to_display = Array.new(sorted_filenames.length) { [] }

  sorted_filenames.map.with_index do |filename, index|
    file = File.stat(filename)
    link_size = file.nlink.to_s.rjust(links_width)
    user_name = Etc.getpwuid(file.uid).name.ljust(user_name_width)
    groupe_name = Etc.getgrgid(file.gid).name.ljust(groupe_name_width)
    file_size = file.size.to_s.rjust(file_size_width)
    block += file.blocks / 2
    last_update = Time.parse(file.mtime.to_s).strftime('%b %e %H:%M')
    permission = permissions[index]

    matrix_to_display[index].push(permission, link_size, user_name, groupe_name, file_size, last_update, filename)
  end

  puts "total #{block}"
  matrix_to_display.each { |item| puts item.join(' ') }
end

ROW_LENGTH = 3
if options['l']
  output_file_details(sorted_filenames, permissions)
else
  output_filenames(ROW_LENGTH, sorted_filenames)
end
