# Math Zoo

A fun educational game that helps children practice addition while collecting animal cards.

## Overview

Math Zoo is a Rails application that combines math practice with the excitement of collecting animals. Players create their own game and solve addition problems to collect animals of increasing difficulty levels. Each correct answer adds a new animal to the player's collection.

## Features

- **Math Practice**: Simple addition problems adjusted to the player's current level
- **Animal Collection**: Collect various animals from different habitats and taxonomic groups
- **Progressive Difficulty**: Animals are organized by difficulty level (indicated by stars)
- **Multiple Games**: Create different games to track progress separately

## How It Works

1. **Create a Game**: Start by creating a new game with a unique name
2. **Solve Math Problems**: You'll be presented with addition problems appropriate to your level
3. **Collect Animals**: Answer correctly to add animals to your collection
4. **View Your Collection**: Check your progress in the animals index view, organized by difficulty level
5. **Progress Through Levels**: As you collect lower-level animals, you'll unlock progressively harder challenges

## Game Mechanics

### Animal Selection

Animals are selected based on their level, always presenting the lowest level animal not yet in your collection. This ensures a smooth progression of difficulty.

### Puzzle Generation

- Puzzles are generated based on the animal's level
- The sum will always be at least twice the animal's level
- Three possible answers are presented, with only one being correct
- Wrong answers are generated to be close to the correct sum
