require 'pathname'

class ShortFormat
  DEFAULT_COL_COUNT = 3

  def initialize(filenames)
    @pathnames = 
      filenames.map do |filename|
        Pathname(filename)
      end
  end

  def run_ls_short_format
    filenames = @pathnames.map(&:basename).map(&:to_s)
    max_filename_count = filenames.map(&:size).max
    row_count = (filenames.count.to_f / DEFAULT_COL_COUNT).ceil
    transposed_filenames = transpose_file(filenames.each_slice(row_count).to_a)
    format_table(transposed_filenames, max_filename_count)
  end

  def transpose_file(filenames)
    filenames[0].zip(*filenames[1..-1])
  end

  def format_table(filenames, max_filename_count)
    filenames.map do |row_files|
      row_files.map { |file| file.to_s.ljust(max_filename_count + 1) }.join.rstrip
    end.join("\n")
  end
end
