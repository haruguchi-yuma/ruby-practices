# frozen_string_literal: true

require_relative './shot'

class Frame
  STRIKE = 10

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @shots = [first_mark, second_mark, third_mark].map { |m| Shot.new(m) }
  end

  def first_shot
    @shots[0]
  end

  def second_shot
    @shots[1]
  end

  def third_shot
    @shots[2]
  end

  def score
    @shots.sum(&:score)
  end

  def strike?
    first_shot.strike?
  end

  def spare?
    !strike? && @shots.take(2).sum(&:score) == 10
  end

  def calc_score(next_frame, after_next_frame, index)
    if last_frame?(index)
      score
    elsif strike?
      score_for_strike(next_frame, after_next_frame, index)
    elsif spare?
      score_for_spare(next_frame)
    else
      score
    end
  end

  def score_for_strike(next_frame, after_next_frame, index)
    # 10フレーム目の2投目がストライクだった場合2フレーム先はないので、適応させない
    if next_frame.strike? && !next_frame.last_frame?(index + 1)
      STRIKE * 2 + after_next_frame.first_shot.score
    else
      STRIKE + next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def score_for_spare(next_frame)
    score + next_frame.first_shot.score
  end

  def last_frame?(index)
    index == 9
  end
end
