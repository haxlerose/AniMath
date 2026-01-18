# Fourth Answer Option Feature Research

## Feature Overview

Currently, the game presents players with **3 answer choices** for each addition puzzle. This feature would add a **4th answer option** to increase difficulty and reduce the probability of guessing correctly from 33% to 25%.

---

## Current Behavior

### Answer Generation

The `PuzzleGenerator` class generates puzzles with exactly 3 answers:
- 1 correct answer (the sum)
- 2 wrong answers (randomly generated within a range near the correct answer)

### Wrong Answer Range

Wrong answers are generated within a constrained range to ensure they are plausible:
- **Lower bound**: `max(1, sum - 2)`
- **Upper bound**: `sum + 3`

This creates a range of 6 possible values (e.g., for sum=10: answers can be 8, 9, 10, 11, 12, or 13).

### Answer Display

Answers are displayed as radio buttons in a horizontal flex layout with gap spacing.

---

## Relevant Code Locations

### 1. PuzzleGenerator (Answer Generation Logic)

**File**: `app/models/puzzle_generator.rb`

| Lines | Description |
|-------|-------------|
| 25-33 | The `answers` private method that generates the answer array |
| 26 | Initializes answers array with correct sum: `answers = [sum]` |
| 27 | Loop condition checking for 3 answers: `while answers.size < 3` |
| 28 | Lower bound calculation: `lower_bound = sum < 3 ? 1 : (sum - 2)` |
| 29 | Wrong answer generation: `wrong_answer = rand(lower_bound..sum + 3)` |
| 30 | Uniqueness check before adding: `answers << wrong_answer if answers.exclude?(wrong_answer)` |
| 32 | Final shuffle: `answers.shuffle` |

**Key consideration**: The current range (6 values) may not provide enough unique options if 4 answers are required. For low sums (e.g., sum=2), the range is only 1-5, which is exactly 5 unique values—sufficient for 4 answers but with less variety.

---

### 2. Game View (Answer Display)

**File**: `app/views/games/show.html.erb`

| Lines | Description |
|-------|-------------|
| 27-40 | Container and loop that renders answer options |
| 27 | Flex container with gap: `<div class="flex flex-wrap gap-3 justify-center">` |
| 28 | Loop iterating over answers: `<% @puzzle[:answers].each do \|answer\| %>` |
| 29-38 | Individual answer option (radio button + label) |
| 30-35 | Radio button with Stimulus data attributes |
| 36-37 | Label with Tailwind styling for the answer button |

**Key consideration**: The flex layout with `flex-wrap` and `gap-3` should accommodate a 4th option without changes, but may need visual review on smaller screens.

---

### 3. Answer Controller (JavaScript Interaction)

**File**: `app/javascript/controllers/answer_controller.js`

| Lines | Description |
|-------|-------------|
| 4 | Target definitions: `static targets = ["answer", "form", "animalCard"]` |
| 12-57 | The `select` method handling answer selection |
| 43-48 | Loop through all answer targets on second incorrect guess |

**Key consideration**: The JavaScript iterates over all `answerTargets` dynamically, so it should handle 4 options without modification.

---

### 4. Styling (CSS)

**File**: `app/assets/tailwind/application.css`

| Lines | Description |
|-------|-------------|
| 11-25 | `@keyframes correctAnswer` animation |
| 27-41 | `@keyframes incorrectAnswer` animation |
| 43-47 | `.correct-answer label` styles |
| 49-53 | `.incorrect-answer label` styles |

**Key consideration**: CSS animations apply to individual answer elements and should work unchanged with 4 options.

---

### 5. Tests (PuzzleGenerator Specs)

**File**: `spec/models/puzzle_generator_spec.rb`

| Lines | Description |
|-------|-------------|
| 59-61 | Test asserting 3 answers: `expect(result[:answers].size).to eq(3)` |
| 64-67 | Test asserting 3 unique answers: `expect(result[:answers].uniq.size).to eq(3)` |
| 75-86 | Test for wrong answer range validation |
| 98 | Mocked rand calls for controlled testing (currently mocks 4 values) |
| 111 | Assertion expecting exactly 3 answers: `contain_exactly(9, 7, 10)` |
| 159 | Size assertion: `expect(result[:answers].size).to eq(3)` |
| 162 | Uniqueness assertion: `expect(result[:answers].uniq.size).to eq(3)` |

---

## Technical Considerations

### 1. Answer Range Sufficiency

The current wrong answer range is `[max(1, sum-2), sum+3]`, providing 6 possible values:

| Sum | Range | Unique Values Available |
|-----|-------|------------------------|
| 2 | 1-5 | 5 values |
| 3 | 1-6 | 6 values |
| 4 | 2-7 | 6 values |
| 5+ | sum-2 to sum+3 | 6 values |

With 4 answers needed (1 correct + 3 wrong), and needing 4 unique values, the current range is sufficient but tight for low sums. Consider whether to expand the range.

### 2. Layout Responsiveness

Current answer container uses:
```html
<div class="flex flex-wrap gap-3 justify-center">
```

On mobile devices, 4 larger answer buttons may wrap to 2 rows. This may be acceptable or may require adjusted button sizing.

### 3. Probability Impact

| Options | Guess Probability |
|---------|-------------------|
| 3 (current) | 33.3% |
| 4 (proposed) | 25.0% |

This represents a 25% reduction in guess success rate.

---

## Files Summary

| File | Purpose | Changes Needed |
|------|---------|----------------|
| `app/models/puzzle_generator.rb` | Generates puzzle answers | Yes - change answer count |
| `app/views/games/show.html.erb` | Displays answer buttons | Review only - should work |
| `app/javascript/controllers/answer_controller.js` | Handles selection | Review only - should work |
| `app/assets/tailwind/application.css` | Answer animations | Review only - should work |
| `spec/models/puzzle_generator_spec.rb` | Tests answer generation | Yes - update assertions |

---

## Edge Cases to Consider

1. **Low sums (sum=2)**: Only 5 unique values available in range 1-5. Still sufficient for 4 answers.

2. **Answer collisions**: The while loop in `answers()` ensures uniqueness but may need more iterations with 4 answers and a tight range.

3. **Visual layout**: Four buttons may look crowded on small mobile screens.

4. **Test mocking**: Existing tests mock exactly 4 `rand` calls (2 addends + 2 wrong answers). With 3 wrong answers, tests need to mock 5 calls.
