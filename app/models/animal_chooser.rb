# frozen_string_literal: true

class AnimalChooser
  def initialize(game)
    @game = game
  end

  def choose
    available_animals = (Animal.all - @game.animals)
    return if available_animals.empty?

    level = available_animals.min_by(&:level).level
    animal_options = available_animals.select { |animal| animal.level == level }
    animal_options.sample
  end
end
