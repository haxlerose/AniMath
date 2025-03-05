# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def new
    @game = Game.new
  end

  def show
    @game = Game.find_by_name(params[:name].downcase)
    redirect_to new_game_path unless @game
  end
end
