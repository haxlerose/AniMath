# frozen_string_literal: true

class PuzzleGenerator
  def initialize(game)
    @game = game
  end

  def generate
    animal = AnimalChooser.new(@game).choose
    return unless animal

    level = animal.level
    sum = 0
    while sum < level * 2
      addend1 = rand(1..level + 2)
      addend2 = rand(1..level + 2)
      sum = addend1 + addend2
    end

    { addend1:, addend2:, sum:, answers: answers(sum) }
  end

  private

  def answers(sum)
    answers = [sum]
    while answers.size < 4
      lower_bound = sum < 3 ? 1 : (sum - 2)
      wrong_answer = rand(lower_bound..sum + 3)
      answers << wrong_answer if answers.exclude?(wrong_answer)
    end
    answers.shuffle
  end
end
