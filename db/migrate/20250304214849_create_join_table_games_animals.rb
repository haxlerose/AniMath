class CreateJoinTableGamesAnimals < ActiveRecord::Migration[8.0]
  def change
    create_join_table :games, :animals do |t|
      t.index [:game_id, :animal_id]
      t.index [:animal_id, :game_id]
    end
  end
end
