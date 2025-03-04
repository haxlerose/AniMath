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

if Rails.env.development?
  Game.find_or_create_by!(name: 'foobar')
end
