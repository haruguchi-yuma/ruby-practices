# frozen_string_literal: true

require_relative './frame'

class Game
  STRIKE = 10

  def initialize(score)
    @marks = score.split(',')
  end

  def score
    frames = divide_into_frames(@marks).map { |frame| Frame.new(*frame) }
    frames.each_with_index.sum do |frame, i|
      if last_frame?(i)
        frame.score
      elsif frame.strike?
        added_strike_point(frames, i)
      elsif frame.spare?
        added_spare_point(frames, i)
      else
        frame.score
      end
    end
  end

  private

  def divide_into_frames(marks)
    frames = []
    10.times do |n|
      frames << if n == 9
                  marks
                elsif marks.first == 'X'
                  [marks.shift]
                else
                  marks.shift(2)
                end
    end
    frames
  end

  def added_strike_point(frames, index)
    if frames[index + 1].strike?
      STRIKE * 2 + frames[index + 2].first_shot.score
    else
      STRIKE + frames[index + 1].score - frames[index + 1].third_shot.score
    end
  end

  def added_spare_point(frames, index)
    frames[index].score + frames[index + 1].first_shot.score
  end

  def last_frame?(index)
    index == 9
  end
end
