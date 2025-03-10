puts 'Seeding database...'
CSV.foreach("db/data/animals.csv", headers: true) do |row|
  Animal.find_or_create_by!(
    name: row["Name"],
    level: row["Level"],
    habitat: row["Habitat"],
    group: row["Group"]
  )
end

puts "#{Animal.count} animals created!"

if Rails.env.development?
  game = Game.find_by(name: 'foobar')
  game&.destroy
  game = Game.create!(name: 'foobar')
  puts "Game #{game.name} created!"
  game.animals = Animal.where(level: 1)
  puts "#{game.animals.count} animals added to game #{game.name}!"
end
