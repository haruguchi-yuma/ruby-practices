# frozen_string_literal: true

require 'pathname'
require 'etc'

class LongFormat
  MODE_TABLE = {
    '7' => 'rwx',
    '6' => 'rw-',
    '5' => 'r-x',
    '4' => 'r--',
    '3' => '-wx',
    '2' => '-w-',
    '1' => '--x',
    '0' => '---'
  }.freeze

  def initialize(filenames)
    @pathnames =
      filenames.map do |filename|
        Pathname(filename)
      end
  end

  def run_ls_long_format
    block_total = 0
    max_nlink = 0
    max_user_length = 0
    max_group_length = 0
    max_size = 0
    @pathnames.each do |pathname|
      stat = pathname.stat
      max_nlink = [max_nlink, stat.nlink.to_s.size].max
      max_user_length = [max_user_length, Etc.getpwuid(stat.uid).name.size].max
      max_group_length = [max_group_length, Etc.getgrgid(stat.gid).name.size].max
      max_size = [max_size, stat.size.to_s.size].max
      block_total += stat.blocks
    end
    rows = ["total #{block_total}"]
    rows += @pathnames.map do |pathname|
      format_table(pathname, max_nlink, max_user_length, max_group_length, max_size)
    end
    rows.join("\n")
  end

  def format_table(pathname, max_nlink, max_user_length, max_group_length, max_size)
    stat = pathname.stat
    ret = ''
    ret += stat.file? ? '-' : 'd'
    mode = format('%#o', stat.mode.to_s)[-3..-1]
    ret += format_mode(mode)
    ret += "  #{stat.nlink.to_s.rjust(max_nlink)}"
    ret += " #{Etc.getpwuid(stat.uid).name.rjust(max_user_length)}"
    ret += "  #{Etc.getgrgid(stat.gid).name.rjust(max_group_length)}"
    ret += "  #{stat.size.to_s.rjust(max_size)}"
    ret += " #{stat.mtime.strftime('%_m %d %R')}"
    ret + " #{pathname.basename}"
  end

  def format_mode(mode)
    ret = ''
    mode.each_char.map do |c|
      ret += MODE_TABLE[c]
    end
    ret
  end
end
