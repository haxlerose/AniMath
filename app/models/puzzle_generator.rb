# frozen_string_literal: true

class PuzzleGenerator
  def initialize(game)
    @game = game
  end

  def generate
    animal = AnimalChooser.new(@game).choose
    level = animal.level

    addend1 = rand(1..level + 2)
    addend2 = rand(1..level + 2)
    sum = addend1 + addend2
    { addend1:, addend2:, sum:, answers: answers(sum) }
  end

  private

  def answers(sum)
    answers = [sum]
    while answers.size < 3
      wrong_answer = rand(1..sum + 5)
      answers << wrong_answer if answers.exclude?(wrong_answer)
    end
    answers.shuffle
  end
end
