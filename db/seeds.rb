puts 'Seeding database...'
[
  { name: 'frog', level: 1, group: :amphibian, habitat: :land },
  { name: 'spider', level: 2, group: :arachnid, habitat: :land },
  { name: 'eagle', level: 3, group: :bird, habitat: :air },
  { name: 'shark', level: 4, group: :fish, habitat: :sea },
  { name: 'ant', level: 5, group: :insect, habitat: :land },
  { name: 'tiger', level: 1, group: :mammal, habitat: :land },
  { name: 'snake', level: 2, group: :reptile, habitat: :land },
  { name: 'whale', level: 3, group: :mammal, habitat: :sea },
  { name: 'octopus', level: 4, group: :mammal, habitat: :sea },
  { name: 'penguin', level: 5, group: :bird, habitat: :land }
].each do |animal|
  Animal.find_or_create_by!(animal)
end

puts "#{Animal.count} animals created!"

if Rails.env.development?
  game = Game.find_or_create_by!(name: 'foobar')
  puts "Game #{game.name} created!"
  game.animals = Animal.where(level: 1)
  puts "#{game.animals.count} animals added to game #{game.name}!"
end
