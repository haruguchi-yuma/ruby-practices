#!/usr/bin/env ruby

require_relative './command'
require_relative './short_format'
require_relative './long_format'

class Ls
  def initialize(pathnames, params)
    @params = params
    @pathnames = pathnames
  end

  def run_ls
    filenames =
      if @params[:dot_match]
        Dir.glob(@pathnames, File::FNM_DOTMATCH).sort
      else
        Dir.glob(@pathnames).sort
      end
    filenames = filenames.reverse if @params[:reverse]
    if @params[:detail]
      long_format = LongFormat.new(filenames)
      long_format.run_ls_long_format
    else
      short_format = ShortFormat.new(filenames)
      short_format.run_ls_short_format
    end
  end
end

command = Command.new
ls = Ls.new(command.pathname, command.params)
puts ls.run_ls
