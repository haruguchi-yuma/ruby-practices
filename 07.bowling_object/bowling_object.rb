#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './game'

score = ARGV[0]
puts Game.calc_score(score)
