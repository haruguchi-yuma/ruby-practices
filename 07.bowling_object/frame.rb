# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(index, first_shot, second_shot = nil, third_shot = nil)
    @index = index
    @shots = [first_shot, second_shot, third_shot]
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
    @shots.compact.sum(&:score)
  end

  def strike?
    first_shot.strike?
  end

  def spare?
    !strike? && @shots.take(2).sum(&:score) == 10
  end

  def calc_score(next_frame, after_next_frame)
    if last_frame?
      score
    elsif strike?
      score_for_strike(next_frame, after_next_frame)
    elsif spare?
      score_for_spare(next_frame)
    else
      score
    end
  end

  def score_for_strike(next_frame, after_next_frame)
    # 10フレーム目の2投目がストライクだった場合2フレーム先はないので、適応させない
    if next_frame.strike? && !next_frame.last_frame?
      score + next_frame.score + after_next_frame.first_shot.score
    else
      score + next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def score_for_spare(next_frame)
    score + next_frame.first_shot.score
  end

  def last_frame?
    @index == 9
  end
end
