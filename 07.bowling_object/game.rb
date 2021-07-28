# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(score)
    @frames = divide_into_frames(score.split(',')).map { |frame| Frame.new(*frame) }
  end

  def calc_score
    @frames.each_with_index.sum do |frame, i|
      frame.calc_score(@frames[i + 1], @frames[i + 2], i)
    end
  end

  private

  def divide_into_frames(marks)
    Array.new(10).map.with_index do |_, i|
      if i == 9
        marks
      elsif marks.first == 'X'
        [marks.shift]
      else
        marks.shift(2)
      end
    end
  end
end
