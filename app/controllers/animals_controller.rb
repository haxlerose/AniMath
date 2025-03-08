# frozen_string_literal: true

class AnimalsController < ApplicationController
  def index
    @game = Game.find(params[:id])
    @animals = Animal.all.group_by(&:level).sort_by do |key, _|
      key
    end.to_h.transform_values { |animals| animals.sort_by(&:name) }
    @owned_animals = @game.animals.to_a
  end
end
