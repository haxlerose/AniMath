# AniMath Game Specifications

AniMath is an educational math game that combines math practice with animal collecting. Players solve math problems to earn animal cards and build their collection.

---

## Game Overview

Players create a game, then solve math puzzles to collect animals. Each correct answer adds a new animal to the player's collection. The game progresses through increasing difficulty levels until all animals have been collected.

---

## Getting Started

### Creating a New Game

- Players enter a unique game name to start a new game
- Game names are case-insensitive (e.g., "MyGame" and "mygame" are the same)
- Each game tracks its own separate animal collection

### Resuming an Existing Game

- Players can search for an existing game by name
- Entering a game name loads that game with its current collection intact

---

## Gameplay

### The Puzzle

Each round presents the player with:

1. An **animal card** showing the animal they can earn
2. A **difficulty rating** displayed as stars (1-7 stars)
3. A **math problem** (e.g., "5 + 3" or "8 − 3")
4. **Four answer choices** to select from

### Answering

- Players select one of the four answer options
- **Correct answer**: The animal is added to the collection, and the next puzzle appears
- **Incorrect answer**: The player may try again (up to 2 attempts per puzzle)
- After 2 incorrect attempts, the correct answer is revealed and the game advances to the next puzzle (animal is not collected)

### Winning

The game is complete when all animals in the database have been collected. A congratulations message is displayed.

---

## Difficulty Progression

### Animal Levels

- Animals are assigned difficulty levels from 1 to 7 (displayed as stars)
- Level 1 animals have the easiest puzzles; Level 7 animals have the hardest

### Progression Rules

- Players always receive animals from the **lowest uncollected level** first
- All Level 1 animals must be collected before Level 2 animals appear
- All Level 2 animals must be collected before Level 3 animals appear
- This pattern continues through all 7 levels

### Operation Progression

The type of math problem changes as players advance:

| Levels | Operation   | Description                           |
|--------|-------------|---------------------------------------|
| 1-3    | Addition    | Players start with addition problems  |
| 4-7    | Subtraction | Subtraction unlocks at level 4        |

### Puzzle Difficulty Scaling

- Higher-level animals have harder math problems
- The numbers in the puzzles increase as the animal level increases
- Subtraction problems always have non-negative results (larger number minus smaller)
- Wrong answer choices are always close to the correct answer to provide challenge

---

## Animal Collection

### Viewing the Collection

Players can view their animal collection at any time, which displays:

- All animals in the game, organized by difficulty level
- **Collected animals** shown in full color with complete details
- **Uncollected animals** shown in grayscale/dimmed

### Animal Attributes

Each animal card displays:

- **Name**: The animal's name
- **Image**: A picture of the animal
- **Level**: Difficulty rating shown as stars
- **Habitat**: Where the animal lives (Air, Land, or Sea)
- **Group**: The animal's classification (Amphibian, Arachnid, Bird, Fish, Insect, Mammal, or Reptile)

### Animal Variety

The game includes animals across:

- **7 difficulty levels**
- **3 habitats**: Air, Land, Sea
- **7 groups**: Amphibian, Arachnid, Bird, Fish, Insect, Mammal, Reptile

---

## Navigation

### During Gameplay

- **Play**: Returns to the current puzzle
- **Set**: Views the animal collection

### From Home

- **Search**: Find and resume an existing game
- **New Game**: Start a fresh game

---

## Visual Feedback

### Correct Answer

- The selected answer flashes green
- The animal card glows to indicate collection
- The game automatically advances to the next puzzle

### Incorrect Answer

- The selected answer flashes red
- The player may select again (if first attempt)
- After second incorrect attempt, the correct answer is highlighted before advancing

---

## Game Persistence

- Games are automatically saved
- Progress is preserved between sessions
- Players can return to any game by searching for its name
- Multiple games can exist simultaneously with different collections
