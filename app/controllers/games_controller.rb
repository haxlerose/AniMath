# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def new
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
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
    @game = Game.find(params[:game_id])
    @animal = Animal.find(params[:animal_id])
    return redirect_to root_path unless @game && @animal

    @guess = params[:guess]
    @sum = params[:sum]
    if @sum.to_i == @guess.to_i
      @game.animals << @animal
      redirect_to game_path(@game)
    else
      redirect_to game_path(@game)
    end
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
