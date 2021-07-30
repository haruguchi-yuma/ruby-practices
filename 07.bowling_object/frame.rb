# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(index, first_shot, second_shot = nil, third_shot = nil)
    @index = index
    @shots = [first_shot, second_shot, third_shot]
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

  protected

  def first_shot_score
    @shots[0].score
  end

  def second_shot_score
    @shots[1].score
  end

  def score
    @shots.compact.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  private

  def score_for_strike(next_frame, after_next_frame)
    if next_frame.strike? && after_next_frame
      score + next_frame.score + after_next_frame.first_shot_score
    else
      score + next_frame.first_shot_score + next_frame.second_shot_score
    end
  end

  def score_for_spare(next_frame)
    score + next_frame.first_shot_score
  end

  def spare?
    !strike? && @shots.take(2).sum(&:score) == 10
  end

  def last_frame?
    @index == 9
  end
end
