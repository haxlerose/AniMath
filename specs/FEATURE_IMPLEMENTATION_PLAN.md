# Implementation Plan: Subtraction Questions Feature

This plan follows Test-Driven Development (TDD) with a Red-Green-Refactor pattern.

---

## Overview

Add subtraction problems as a new question type that unlocks at levels 4-7, while keeping addition for levels 1-3. This requires:

1. Refactoring the data structure from `addend1/addend2/sum` to `num1/num2/result/operation`
2. Adding operation-based puzzle generation logic
3. Updating views to display the correct operator
4. Updating the controller to use the new `result` field
5. Updating documentation

---

## Phase 1: Refactor Data Structure (Addition Only)

Before adding subtraction, refactor the existing addition code to use the new unified data structure. This ensures backward compatibility and makes adding subtraction straightforward.

### Step 1.1: Update Tests for New Data Structure (RED)

**File**: `spec/models/puzzle_generator_spec.rb`

Update existing tests to expect the new hash structure:
- Change `:addend1` → `:num1`
- Change `:addend2` → `:num2`
- Change `:sum` → `:result`
- Add expectation for `:operation` key with value `:addition`

**Tests to modify**:
- Line 41: Expect `[:num1, :num2, :result, :operation, :answers]` keys
- Line 46: `result[:result]` should equal `result[:num1] + result[:num2]`
- Line 51: `result[:result]` should be >= level constraint
- Line 56: `result[:answers]` should include `result[:result]`
- Lines 70-72: Check `:num1` and `:num2` ranges
- Lines 77-85: Wrong answers based on `:result`
- All edge case tests similarly updated

**Add new test**:
- Test that `operation` returns `:addition` for levels 1-3

### Step 1.2: Update PuzzleGenerator for New Structure (GREEN)

**File**: `app/models/puzzle_generator.rb`

Change the return hash:
```ruby
{ num1: addend1, num2: addend2, result: sum, operation: :addition, answers: answers(sum) }
```

Rename internal variables for clarity:
- `addend1` → `num1`
- `addend2` → `num2`
- `sum` → `result`

Rename `answers(sum)` parameter to `answers(result)`.

### Step 1.3: Update View (GREEN)

**File**: `app/views/games/show.html.erb`

- Line 5: Change `@puzzle[:sum]` → `@puzzle[:result]`
- Line 11: Change hidden field name from `:sum` to `:result`
- Line 25: Change `@puzzle[:addend1]` → `@puzzle[:num1]`, `@puzzle[:addend2]` → `@puzzle[:num2]`
- Line 25: Add operator from `@puzzle[:operation]`:
  ```erb
  <%= @puzzle[:operation] == :addition ? '+' : '−' %>
  ```

### Step 1.4: Update Controller (GREEN)

**File**: `app/controllers/games_controller.rb`

- Line 38: Change `params[:sum]` → `params[:result]`

### Step 1.5: Verify All Tests Pass (REFACTOR)

Run the test suite to ensure the refactoring is complete and nothing is broken.

---

## Phase 2: Add Subtraction Support

### Step 2.1: Add Tests for Subtraction (RED)

**File**: `spec/models/puzzle_generator_spec.rb`

Add new context for subtraction levels (4-7):

```ruby
context 'when animal is level 4-7 (subtraction)' do
  let(:animal) { instance_double('Animal', level: 5) }

  before do
    allow(animal_chooser).to receive(:choose).and_return(animal)
  end

  it 'returns :subtraction as the operation' do
    result = subject.generate
    expect(result[:operation]).to eq(:subtraction)
  end

  it 'ensures num1 >= num2 (no negative results)' do
    10.times do
      result = subject.generate
      expect(result[:num1]).to be >= result[:num2]
    end
  end

  it 'ensures result equals num1 - num2' do
    result = subject.generate
    expect(result[:result]).to eq(result[:num1] - result[:num2])
  end

  it 'ensures result meets minimum difference for level' do
    # Level 4: min_diff 1, Level 5: min_diff 2, etc.
    result = subject.generate
    min_diff = animal.level - 3  # Level 4→1, 5→2, 6→3, 7→4
    expect(result[:result]).to be >= min_diff
  end

  it 'ensures wrong answers are never negative' do
    10.times do
      result = subject.generate
      result[:answers].each do |answer|
        expect(answer).to be >= 0
      end
    end
  end
end
```

Add tests for each subtraction level (4, 5, 6, 7) to verify number ranges.

### Step 2.2: Implement Subtraction Generation (GREEN)

**File**: `app/models/puzzle_generator.rb`

Add configuration constants:
```ruby
ADDITION_RANGES = {
  1 => { max: 5, min_sum: 2 },
  2 => { max: 7, min_sum: 4 },
  3 => { max: 9, min_sum: 6 }
}.freeze

SUBTRACTION_RANGES = {
  4 => { max: 6, min_diff: 1 },
  5 => { max: 8, min_diff: 2 },
  6 => { max: 10, min_diff: 3 },
  7 => { max: 12, min_diff: 4 }
}.freeze
```

Refactor `generate` method:
```ruby
def generate
  animal = AnimalChooser.new(@game).choose
  return unless animal

  level = animal.level
  level <= 3 ? generate_addition(level) : generate_subtraction(level)
end
```

Add private methods:
```ruby
def generate_addition(level)
  config = ADDITION_RANGES[level]
  # ... existing addition logic with new structure
end

def generate_subtraction(level)
  config = SUBTRACTION_RANGES[level]
  diff = 0
  while diff < config[:min_diff]
    a = rand(1..config[:max])
    b = rand(1..config[:max])
    num1 = [a, b].max
    num2 = [a, b].min
    diff = num1 - num2
  end
  { num1:, num2:, result: diff, operation: :subtraction, answers: answers(diff) }
end
```

Update `answers` method to floor at 0:
```ruby
def answers(result)
  answers = [result]
  while answers.size < 4
    lower_bound = [result - 2, 0].max  # Never go below 0
    wrong_answer = rand(lower_bound..result + 3)
    answers << wrong_answer if answers.exclude?(wrong_answer)
  end
  answers.shuffle
end
```

### Step 2.3: Run Tests and Refactor (REFACTOR)

Verify all tests pass and refactor for clarity if needed.

---

## Phase 3: Update Documentation

### Step 3.1: Update SPECS.md

**File**: `specs/SPECS.md`

Changes:
1. Line 3: "addition practice" → "math practice"
2. Lines 9, 36: Update references from "addition puzzles/problems" to "math puzzles/problems"
3. Add new section documenting operation progression:
   - Levels 1-3: Addition
   - Levels 4-7: Subtraction
4. Update "Puzzle Difficulty Scaling" section to mention both operations

---

## File Change Summary

| File | Changes |
|------|---------|
| `spec/models/puzzle_generator_spec.rb` | Update existing tests + add subtraction tests |
| `app/models/puzzle_generator.rb` | New data structure, add subtraction generation |
| `app/views/games/show.html.erb` | Use new field names, display dynamic operator |
| `app/controllers/games_controller.rb` | Change `params[:sum]` to `params[:result]` |
| `specs/SPECS.md` | Update terminology and add operation documentation |

---

## Testing Checklist

### Addition (Levels 1-3)
- [x] Returns correct hash structure with `:num1, :num2, :result, :operation, :answers`
- [x] `operation` is `:addition`
- [x] `result` equals `num1 + num2`
- [x] Numbers are within level-appropriate ranges
- [x] 4 unique answers including correct one
- [x] Wrong answers within valid range

### Subtraction (Levels 4-7)
- [x] Returns correct hash structure
- [x] `operation` is `:subtraction`
- [x] `result` equals `num1 - num2`
- [x] `num1 >= num2` (no negative results)
- [x] Minimum difference constraint met per level
- [x] Numbers are within level-appropriate ranges
- [x] 4 unique answers including correct one
- [x] Wrong answers never negative
- [x] Wrong answers within valid range

### Integration
- [x] View displays correct operator (+ or −)
- [x] Form submits correct answer for validation
- [ ] Animals are collected on correct answer
- [ ] Game progresses through all 7 levels

---

## Acceptance Criteria Verification

1. ✅ Levels 1-3 animals present addition problems
2. ✅ Levels 4-7 animals present subtraction problems
3. ✅ Subtraction problems never result in negative answers
4. ✅ Wrong answers for subtraction are never negative
5. ✅ Difficulty scales appropriately across subtraction levels
6. ✅ Game description updated to "math practice"
7. ✅ All existing addition functionality continues to work
