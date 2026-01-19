# frozen_string_literal: true

class PuzzleGenerator
  def initialize(game)
    @game = game
  end

  def generate
    animal = AnimalChooser.new(@game).choose
    return unless animal

    level = animal.level
    result = 0
    while result < level * 2
      num1 = rand(1..level + 2)
      num2 = rand(1..level + 2)
      result = num1 + num2
    end

    { num1:, num2:, result:, operation: :addition, answers: answers(result) }
  end

  private

  def answers(result)
    answers = [result]
    while answers.size < 4
      lower_bound = result < 3 ? 1 : (result - 2)
      wrong_answer = rand(lower_bound..result + 3)
      answers << wrong_answer if answers.exclude?(wrong_answer)
    end
    answers.shuffle
  end
end
