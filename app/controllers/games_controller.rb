# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show guess]
  def index; end

  def new
    @game = Game.new
  end

  def show
    return redirect_to root_path unless @game

    @animal = AnimalChooser.new(@game).choose
    @puzzle = PuzzleGenerator.new(@game).generate
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to game_path(@game)
    else
      redirect_to new_game_path
    end
  end

  def search
    @game = Game.find_by_name(params[:name].downcase)
    return redirect_to root_path unless @game

    redirect_to game_path(@game)
  end

  def guess
    @animal = Animal.find(params[:animal_id])
    return redirect_to root_path unless @game && @animal

    @game.animals << @animal if params[:result].to_i == params[:guess].to_i

    redirect_to game_path(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name)
  end
end
