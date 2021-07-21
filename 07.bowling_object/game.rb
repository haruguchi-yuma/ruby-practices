require_relative './frame'

class Game
  def initialize(score)
    @marks = score.split(',')
  end

  def score
    frames = divide_into_frames(@marks).map { |frame| Frame.new(*frame)}
    
    frames.each_with_index.sum do |frame, i|
      frame.score
    end
  end

  def divide_into_frames(marks)
    frames = []
    10.times do |n|
      if n == 9
        frames << marks
      elsif marks.first == 'X'
        frames << [marks.shift]
      else
        frames << marks.shift(2)
      end
    end
    frames
  end

  def added_strike_point(frames, i)

  end
end

