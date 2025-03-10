# frozen_string_literal: true

class AnimalsController < ApplicationController
  def index
    @game = Game.find(params[:id])
    grouped_animals = Animal.all.group_by(&:level)
    @animals = grouped_animals.sort_by { |key, _| key }.to_h.transform_values { |animals| animals.sort_by(&:name) }
    @owned_animals = @game.animals.to_a
  end
end
