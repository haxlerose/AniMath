class CreateAnimals < ActiveRecord::Migration[8.0]
  def change
    create_table :animals do |t|
      t.string :name
      t.integer :level
      t.integer :group
      t.integer :habitat
      t.timestamps
    end
  end
end
