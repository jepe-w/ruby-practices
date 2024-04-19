#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'time'
require 'etc'

def fetch_options
  ARGV.getopts('arl')
end
options = fetch_options

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

def file_permissions(sorted_filenames, file_type, permission_type)
  sorted_filenames.map do |filename|
    file = File.stat(filename)
    permission = file.mode.to_s(8)
    type = file.ftype
    split_permission = permission[-3..].split('')
    split_permission.map.with_index do |item, i|
      split_permission[i] = permission_type[item]
    end
    file_type[type] + split_permission[0] + split_permission[1] + split_permission[2]
  end
end

def file_stats(sorted_filenames)
  stats = sorted_filenames.map { |filename| File.stat(filename) }
  stats.map do |file_stat|
    {
      link_size: file_stat.nlink.to_s,
      file_size: file_stat.size.to_s,
      user_name: Etc.getpwuid(file_stat.uid).name,
      groupe_name: Etc.getgrgid(file_stat.gid).name,
      file_block: file_stat.blocks,
      last_update: Time.parse(file_stat.mtime.to_s).strftime('%b %e %H:%M')
    }
  end
end

def output_file_stats(sorted_filenames, file_stats, permissions)
  block = 0
  links_width = file_stats.map { |stat| stat[:link_size].length }.max
  file_size_width = file_stats.map { |stat| stat[:file_size].length }.max
  user_name_width = file_stats.map { |stat| stat[:user_name].length }.max
  groupe_name_width = file_stats.map { |stat| stat[:groupe_name].length }.max
  matrix_to_display = Array.new(sorted_filenames.length) { [] }

  file_stats.map.with_index do |filestat, index|
    link_size = filestat[:link_size].rjust(links_width)
    user_name = filestat[:user_name].ljust(user_name_width)
    groupe_name = filestat[:groupe_name].ljust(groupe_name_width)
    file_size = filestat[:file_size].rjust(file_size_width)
    block += filestat[:file_block] / 2
    last_update = filestat[:last_update]
    permission = permissions[index]
    filename = sorted_filenames[index]
    matrix_to_display[index].push(permission, link_size, user_name, groupe_name, file_size, last_update, filename)
  end

  puts "total #{block}"
  matrix_to_display.each { |item| puts item.join(' ') }
end

ROW_LENGTH = 3
FILE_TYPE = { 'file' => '-', 'directory' => 'd', 'characterSpecial' => 'c', 'blockSpecial' => 'b', 'fifo' => 'p', 'link' => 'l', 'socket' => 's' }.freeze
PERMISSION_TYPE = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--r', '0' => '---' }.freeze
if options['l']
  file_stats = file_stats(sorted_filenames)
  permissions = file_permissions(sorted_filenames, FILE_TYPE, PERMISSION_TYPE)
  output_file_stats(sorted_filenames, file_stats, permissions)
else
  output_filenames(ROW_LENGTH, sorted_filenames)
end
