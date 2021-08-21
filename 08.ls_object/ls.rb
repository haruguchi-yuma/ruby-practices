#!/usr/bin/env ruby
# frozen_string_literal: true

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
    
    format = (@params[:detail] ? LongFormat : ShortFormat).new(filenames)
    format.run
  end
end

command = Command.new
ls = Ls.new(command.pathname, command.params)
puts ls.run_ls
