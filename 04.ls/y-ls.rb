#!/usr/bin/env ruby
# frozen_string_literal: true

@word_counts = []
Dir.foreach('.') do |item|
  next if item == '.' || item =~ /^\..*/

  @word_counts.push(item.length)
end

@max = @word_counts.max
@directories = []
Dir.foreach('.') do |item|
  next if item == '.' || item =~ /^\..*/

  blank = ' ' * (@max - item.length)
  @directories.push(item + blank)
end

def output_dhirectories
  @directories = @directories.sort
  @directories = @directories.each_slice(3).to_a
  @directories.each { |item| puts item.join('  ') }
end

output_dhirectories
