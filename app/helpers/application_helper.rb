# frozen_string_literal: true

module ApplicationHelper
  def animal_path(animal)
    "animals/#{animal.name.tr(' ', '-').downcase}.webp"
  end
end
