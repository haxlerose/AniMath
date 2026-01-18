# Fourth Answer Option - Implementation Plan

This document outlines the implementation plan for adding a fourth answer option to AniMath puzzles, reducing the probability of guessing correctly from 33% to 25%.

**Approach**: Test-Driven Development (Red-Green-Refactor)

**Testing Philosophy**: Test only the public interface (`PuzzleGenerator#generate`), not private implementation details.

---

## Summary of Changes

| File | Change Type | Scope |
|------|-------------|-------|
| `spec/models/puzzle_generator_spec.rb` | Test updates | Update behavior expectations |
| `app/models/puzzle_generator.rb` | Code change | 1 line |
| `app/views/games/show.html.erb` | Review only | No changes expected |
| `app/javascript/controllers/answer_controller.js` | Review only | No changes expected |
| `app/assets/tailwind/application.css` | Review only | No changes expected |

---

## Phase 1: RED - Update Tests to Expect 4 Answers

Update tests first. After this phase, tests will fail because the implementation still generates 3 answers.

### Step 1.1: Update Answer Count Test

**File**: `spec/models/puzzle_generator_spec.rb`

| Line | Current | New |
|------|---------|-----|
| 61 | `expect(result[:answers].size).to eq(3)` | `expect(result[:answers].size).to eq(4)` |

This test verifies the public behavior: calling `generate` returns a hash with exactly 4 answers.

### Step 1.2: Update Uniqueness Test

**File**: `spec/models/puzzle_generator_spec.rb`

| Line | Current | New |
|------|---------|-----|
| 66 | `expect(result[:answers].uniq.size).to eq(3)` | `expect(result[:answers].uniq.size).to eq(4)` |

This test verifies that all 4 answers are unique.

### Step 1.3: Update Edge Case Tests

**File**: `spec/models/puzzle_generator_spec.rb`

| Line | Current | New |
|------|---------|-----|
| 159 | `expect(result[:answers].size).to eq(3)` | `expect(result[:answers].size).to eq(4)` |
| 162 | `expect(result[:answers].uniq.size).to eq(3)` | `expect(result[:answers].uniq.size).to eq(4)` |

### Step 1.4: Remove Implementation-Specific Tests

**File**: `spec/models/puzzle_generator_spec.rb`

Delete the "controlled randomness" test block (lines 90-113). This test mocks the private `rand` calls, which tests implementation details rather than public behavior. The remaining tests adequately verify the expected behavior:
- `generate` returns 4 answers
- All answers are unique
- The correct sum is included
- Wrong answers are within the expected range

Similarly, update the edge case test at lines 116-136 to remove the `rand` mocking. Replace with a behavioral test:

```ruby
context 'when sum is less than 3' do
  let(:animal) { instance_double('Animal', level: 1) }

  before do
    allow(animal_chooser).to receive(:choose).and_return(animal)
  end

  it 'generates 4 unique answers even for low sums' do
    # Run multiple times to account for randomness
    10.times do
      result = subject.generate
      expect(result[:answers].size).to eq(4)
      expect(result[:answers].uniq.size).to eq(4)
      expect(result[:answers]).to include(result[:sum])
    end
  end

  it 'keeps wrong answers within valid range for low sums' do
    10.times do
      result = subject.generate
      correct_sum = result[:sum]
      wrong_answers = result[:answers] - [correct_sum]

      lower_bound = correct_sum < 3 ? 1 : (correct_sum - 2)
      upper_bound = correct_sum + 3

      wrong_answers.each do |answer|
        expect(answer).to be_between(lower_bound, upper_bound)
      end
    end
  end
end
```

### Step 1.5: Run Tests (Expect Failure)

```bash
bundle exec rspec spec/models/puzzle_generator_spec.rb
```

**Expected**: Tests fail with messages like:
- `expected: 4, got: 3`

This confirms we are in the RED state.

---

## Phase 2: GREEN - Implement the Feature

Make the minimal change to pass the tests.

### Step 2.1: Modify PuzzleGenerator

**File**: `app/models/puzzle_generator.rb`

| Line | Current | New |
|------|---------|-----|
| 27 | `while answers.size < 3` | `while answers.size < 4` |

This is the only code change needed.

### Step 2.2: Run Tests (Expect Success)

```bash
bundle exec rspec spec/models/puzzle_generator_spec.rb
```

**Expected**: All tests pass.

This confirms we are in the GREEN state.

---

## Phase 3: REFACTOR - Review and Clean Up

### Step 3.1: Review Code Quality

Examine the implementation for any improvements. In this case, the change is minimal and the existing code structure is clean. No refactoring needed.

### Step 3.2: Run Full Test Suite

```bash
bundle exec rspec
```

Ensure no other tests were affected by the change.

---

## Phase 4: Verify Existing Components (No Changes Expected)

### Step 4.1: Verify View Template

**File**: `app/views/games/show.html.erb`

The answer display loop at lines 28-39 iterates dynamically:
```erb
<% @puzzle[:answers].each do |answer| %>
```

This will automatically render 4 buttons. No code changes needed.

### Step 4.2: Verify JavaScript Controller

**File**: `app/javascript/controllers/answer_controller.js`

The controller iterates over all answer targets dynamically:
```javascript
this.answerTargets.forEach((answer) => {
```

No code changes needed.

### Step 4.3: Verify CSS Animations

**File**: `app/assets/tailwind/application.css`

Animations apply to individual elements. No code changes needed.

---

## Phase 5: Manual Testing

### Step 5.1: Functional Testing

1. Start a new game
2. Verify puzzles display 4 answer options
3. Test correct answer selection (should animate and advance)
4. Test first incorrect answer (should animate and allow retry)
5. Test second incorrect answer (should reveal correct answer and advance)
6. Complete several puzzles across different difficulty levels

### Step 5.2: Visual Testing

1. **Desktop**: Verify 4 buttons display appropriately
2. **Tablet**: Verify layout remains usable
3. **Mobile**: Verify buttons wrap appropriately

### Step 5.3: Edge Case Testing

1. **Level 1 animals**: Verify 4 unique answers generate correctly for low sums (sum=2 has only 5 possible values in range)

---

## Rollback Plan

If issues arise, revert the single line change in `puzzle_generator.rb`:

```ruby
# Revert from:
while answers.size < 4

# Back to:
while answers.size < 3
```

And revert test expectations from 4 back to 3.

---

## Technical Notes

### Answer Range Analysis

The wrong answer range `[max(1, sum-2), sum+3]` provides:

| Sum | Range | Available Values | Sufficient for 4 Answers? |
|-----|-------|------------------|---------------------------|
| 2 | 1-5 | 5 values | Yes (minimum case) |
| 3 | 1-6 | 6 values | Yes |
| 4+ | sum-2 to sum+3 | 6 values | Yes |

The range is sufficient for generating 4 unique answers in all cases.

### Why We Removed the Controlled Randomness Tests

The original tests at lines 90-113 and 116-136 mocked `rand` to control internal behavior. This approach:

1. **Tests implementation, not behavior**: If we refactor how wrong answers are generated internally, these tests break even if the public behavior is unchanged.
2. **Creates brittle tests**: The tests depend on knowing exactly how many times `rand` is called and in what order.
3. **Is redundant**: The behavioral tests (answer count, uniqueness, range validation) already verify the correct output without caring how it's achieved.

The replacement behavioral tests verify the same guarantees through the public interface.
