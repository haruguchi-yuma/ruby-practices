# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(score)
    @frames = divide_into_frames(score).map.with_index do |frame, i|
      Frame.new(i, *frame)
    end
  end

  def self.calc_score(score)
    new(score).calc_score
  end

  def calc_score
    @frames.each_with_index.sum do |frame, i|
      frame.calc_score(@frames[i + 1], @frames[i + 2])
    end
  end

  private

  def divide_into_frames(score)
    marks = score.split(',')
    shots = marks.map { |m| Shot.new(m) }
    Array.new(10) do |i|
      if i == 9
        shots
      elsif shots.first.strike?
        [shots.shift]
      else
        shots.shift(2)
      end
    end
  end
end
