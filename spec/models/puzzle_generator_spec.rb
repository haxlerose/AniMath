# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PuzzleGenerator do
  let(:game) { instance_double('Game') }
  let(:animal_chooser) { instance_double('AnimalChooser') }

  subject { described_class.new(game) }

  before do
    allow(AnimalChooser).to receive(:new).with(game).and_return(animal_chooser)
  end

  describe '#initialize' do
    it 'initializes with a game' do
      expect(subject.instance_variable_get(:@game)).to eq(game)
    end
  end

  describe '#generate' do
    context 'when no animal is chosen' do
      before do
        allow(animal_chooser).to receive(:choose).and_return(nil)
      end

      it 'returns nil' do
        expect(subject.generate).to be_nil
      end
    end

    context 'when an animal is chosen' do
      let(:animal) { instance_double('Animal', level: 3) }

      before do
        allow(animal_chooser).to receive(:choose).and_return(animal)
      end

      it 'returns a hash with the correct keys' do
        result = subject.generate
        expect(result).to include(:num1, :num2, :result, :operation, :answers)
      end

      it 'returns :addition as the operation for levels 1-3' do
        result = subject.generate
        expect(result[:operation]).to eq(:addition)
      end

      it 'ensures result is equal to num1 + num2' do
        result = subject.generate
        expect(result[:result]).to eq(result[:num1] + result[:num2])
      end


      it 'includes the correct result in the answers' do
        result = subject.generate
        expect(result[:answers]).to include(result[:result])
      end

      it 'returns 4 possible answers' do
        result = subject.generate
        expect(result[:answers].size).to eq(4)
      end

      it 'returns unique answers' do
        result = subject.generate
        expect(result[:answers].uniq.size).to eq(4)
      end

      it 'ensures num1 and num2 are within expected range for level 3' do
        # Level 3: max 9
        10.times do
          result = subject.generate
          expect(result[:num1]).to be_between(1, 9)
          expect(result[:num2]).to be_between(1, 9)
        end
      end

      it 'ensures result meets minimum sum for level 3' do
        # Level 3: min_sum 6
        10.times do
          result = subject.generate
          expect(result[:result]).to be >= 6
        end
      end

      it 'ensures wrong answers are within expected range' do
        result = subject.generate
        correct_result = result[:result]
        wrong_answers = result[:answers] - [correct_result]

        lower_bound = [correct_result - 2, 0].max  # Floor at 0, never negative
        upper_bound = correct_result + 3

        wrong_answers.each do |answer|
          expect(answer).to be_between(lower_bound, upper_bound)
        end
      end
    end
  end

  context 'when animal is level 4-7 (subtraction)' do
    let(:animal) { instance_double('Animal', level: 5) }

    before do
      allow(animal_chooser).to receive(:choose).and_return(animal)
    end

    it 'returns a hash with the correct keys' do
      result = subject.generate
      expect(result).to include(:num1, :num2, :result, :operation, :answers)
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
      # Level 4: min_diff 1, Level 5: min_diff 2, Level 6: min_diff 3, Level 7: min_diff 4
      10.times do
        result = subject.generate
        min_diff = animal.level - 3 # Level 4→1, 5→2, 6→3, 7→4
        expect(result[:result]).to be >= min_diff
      end
    end

    it 'returns 4 unique answers including the correct result' do
      result = subject.generate
      expect(result[:answers].size).to eq(4)
      expect(result[:answers].uniq.size).to eq(4)
      expect(result[:answers]).to include(result[:result])
    end

    it 'ensures wrong answers are never negative' do
      10.times do
        result = subject.generate
        result[:answers].each do |answer|
          expect(answer).to be >= 0
        end
      end
    end

    it 'ensures num1 and num2 are within expected range for level 5' do
      # Level 5: max 8
      10.times do
        result = subject.generate
        expect(result[:num1]).to be_between(1, 8)
        expect(result[:num2]).to be_between(1, 8)
      end
    end
  end

  context 'subtraction level 4' do
    let(:animal) { instance_double('Animal', level: 4) }

    before do
      allow(animal_chooser).to receive(:choose).and_return(animal)
    end

    it 'uses max of 6 and min_diff of 1' do
      10.times do
        result = subject.generate
        expect(result[:num1]).to be_between(1, 6)
        expect(result[:num2]).to be_between(1, 6)
        expect(result[:result]).to be >= 1
      end
    end
  end

  context 'subtraction level 6' do
    let(:animal) { instance_double('Animal', level: 6) }

    before do
      allow(animal_chooser).to receive(:choose).and_return(animal)
    end

    it 'uses max of 10 and min_diff of 3' do
      10.times do
        result = subject.generate
        expect(result[:num1]).to be_between(1, 10)
        expect(result[:num2]).to be_between(1, 10)
        expect(result[:result]).to be >= 3
      end
    end
  end

  context 'subtraction level 7' do
    let(:animal) { instance_double('Animal', level: 7) }

    before do
      allow(animal_chooser).to receive(:choose).and_return(animal)
    end

    it 'uses max of 12 and min_diff of 4' do
      10.times do
        result = subject.generate
        expect(result[:num1]).to be_between(1, 12)
        expect(result[:num2]).to be_between(1, 12)
        expect(result[:result]).to be >= 4
      end
    end
  end

  context 'addition level 1' do
    let(:animal) { instance_double('Animal', level: 1) }

    before do
      allow(animal_chooser).to receive(:choose).and_return(animal)
    end

    it 'uses max of 5 and min_sum of 2' do
      10.times do
        result = subject.generate
        expect(result[:num1]).to be_between(1, 5)
        expect(result[:num2]).to be_between(1, 5)
        expect(result[:result]).to be >= 2
      end
    end
  end

  context 'addition level 2' do
    let(:animal) { instance_double('Animal', level: 2) }

    before do
      allow(animal_chooser).to receive(:choose).and_return(animal)
    end

    it 'uses max of 7 and min_sum of 4' do
      10.times do
        result = subject.generate
        expect(result[:num1]).to be_between(1, 7)
        expect(result[:num2]).to be_between(1, 7)
        expect(result[:result]).to be >= 4
      end
    end
  end

  context 'edge cases' do
    context 'when result is less than 3' do
      let(:animal) { instance_double('Animal', level: 1) }

      before do
        allow(animal_chooser).to receive(:choose).and_return(animal)
      end

      it 'generates 4 unique answers even for low results' do
        # Run multiple times to account for randomness
        10.times do
          result = subject.generate
          expect(result[:answers].size).to eq(4)
          expect(result[:answers].uniq.size).to eq(4)
          expect(result[:answers]).to include(result[:result])
        end
      end

      it 'keeps wrong answers within valid range for low results' do
        10.times do
          result = subject.generate
          correct_result = result[:result]
          wrong_answers = result[:answers] - [correct_result]

          lower_bound = [correct_result - 2, 0].max  # Floor at 0, never negative
          upper_bound = correct_result + 3

          wrong_answers.each do |answer|
            expect(answer).to be_between(lower_bound, upper_bound)
          end
        end
      end
    end

    context 'when generating a puzzle with required result' do
      let(:animal) { instance_double('Animal', level: 3) }

      before do
        allow(animal_chooser).to receive(:choose).and_return(animal)
      end

      it 'ensures the puzzle meets level 3 requirements' do
        result = subject.generate

        # Level 3: min_sum 6, max 9
        expect(result[:result]).to be >= 6
        expect(result[:num1] + result[:num2]).to eq(result[:result])

        # Verify num1 and num2 are within expected range for level 3
        expect(result[:num1]).to be_between(1, 9)
        expect(result[:num2]).to be_between(1, 9)

        # Verify answers include the correct result
        expect(result[:answers]).to include(result[:result])

        # Verify we have the right number of answers
        expect(result[:answers].size).to eq(4)

        # Verify all answers are unique
        expect(result[:answers].uniq.size).to eq(4)
      end
    end
  end
end
