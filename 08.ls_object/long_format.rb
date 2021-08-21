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

  def run
    row_data = @pathnames.map do |pathname|
      stat = pathname.stat
      build_data(pathname, stat)
    end
    block_total = row_data.sum { |data| data[:block] }
    total = "total #{block_total}"
    body = render_format(row_data)
    [total, *body].join("\n")
  end

  private

  def build_data(pathname, stat)
    {
      filetype_and_mode: format_filetype_and_mode(stat),
      nlink: stat.nlink.to_s,
      user: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size.to_s,
      mtime: stat.mtime.strftime('%_m %e %R'),
      filename: pathname.basename,
      block: stat.blocks
    }
  end

  def render_format(row_data)
    row_data.map do |data|
      format_table(data, *max_items(row_data))
    end
  end

  def max_items(row_data)
    items = %i[nlink user group size]
    items.map { |item| row_data.map { |data| data[item].size }.max }
  end

  def format_filetype_and_mode(stat)
    filetype = stat.file? ? '-' : 'd'
    mode = format_mode(stat.mode.to_s(8)[-3..-1])
    filetype + mode
  end

  def format_table(data, max_nlink, max_user, max_group, max_size)
    [
      data[:filetype_and_mode],
      "  #{data[:nlink].rjust(max_nlink)}",
      " #{data[:user].ljust(max_user)}",
      "  #{data[:group].ljust(max_group)}",
      "  #{data[:size].rjust(max_size)}",
      " #{data[:mtime]}",
      " #{data[:filename]}"
    ].join
  end

  def format_mode(mode)
    mode.each_char.map do |c|
      MODE_TABLE[c]
    end.join
  end
end
