# frozen_string_literal: true

require_relative './shot'

class Frame

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @shots = [first_mark, second_mark, third_mark].map { |m| Shot.new(m)}
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
    @shots.take(2).sum(&:score) == 10
  end
end
