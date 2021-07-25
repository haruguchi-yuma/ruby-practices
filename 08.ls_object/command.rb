require 'optparse'
require 'pathname'

class Command
  attr_reader :params
  
  def initialize
    @ARGV = ARGV
    @params = { detail: false, reverse: false, dot_match: false }
    option_parse
  end

  def pathname
    path = @ARGV[0] || '.'
    pathname = Pathname(path).join('*')
  end
  
  private
  
  def option_parse
    opt = OptionParser.new
    opt.on('-l') { |v| params[:detail] = v }
    opt.on('-r') { |v| params[:reverse] = v }
    opt.on('-a') { |v| params[:dot_match] = v }
    opt.parse!(@ARGV)  
  end
end
