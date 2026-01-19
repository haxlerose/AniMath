# frozen_string_literal: true

class PuzzleGenerator
  SUBTRACTION_RANGES = {
    4 => { max: 6, min_diff: 1 },
    5 => { max: 8, min_diff: 2 },
    6 => { max: 10, min_diff: 3 },
    7 => { max: 12, min_diff: 4 }
  }.freeze

  def initialize(game)
    @game = game
  end

  def generate
    animal = AnimalChooser.new(@game).choose
    return unless animal

    level = animal.level
    level <= 3 ? generate_addition(level) : generate_subtraction(level)
  end

  private

  def generate_addition(level)
    result = 0
    while result < level * 2
      num1 = rand(1..level + 2)
      num2 = rand(1..level + 2)
      result = num1 + num2
    end

    { num1:, num2:, result:, operation: :addition, answers: answers(result) }
  end

  def generate_subtraction(level)
    config = SUBTRACTION_RANGES[level]
    diff = 0
    while diff < config[:min_diff]
      a = rand(1..config[:max])
      b = rand(1..config[:max])
      num1 = [a, b].max # minuend (larger number first)
      num2 = [a, b].min # subtrahend
      diff = num1 - num2
    end

    { num1:, num2:, result: diff, operation: :subtraction, answers: answers(diff) }
  end

  def answers(result)
    answers = [result]
    while answers.size < 4
      lower_bound = [result - 2, 0].max # Never go below 0
      wrong_answer = rand(lower_bound..result + 3)
      answers << wrong_answer if answers.exclude?(wrong_answer)
    end
    answers.shuffle
  end
end
