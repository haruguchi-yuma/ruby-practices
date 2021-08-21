# frozen_string_literal: true

require 'optparse'
require 'pathname'

class Command
  attr_reader :params

  def initialize
    @argv = ARGV
    @params = { detail: false, reverse: false, dot_match: false }
    option_parse
  end

  def pathname
    path = @argv[0] || '.'
    Pathname(path).join('*')
  end

  private

  def option_parse
    opt = OptionParser.new
    opt.on('-l') { |v| params[:detail] = v }
    opt.on('-r') { |v| params[:reverse] = v }
    opt.on('-a') { |v| params[:dot_match] = v }
    opt.parse!(@argv)
  end
end
