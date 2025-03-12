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
        expect(result).to include(:addend1, :addend2, :sum, :answers)
      end

      it 'ensures sum is equal to addend1 + addend2' do
        result = subject.generate
        expect(result[:sum]).to eq(result[:addend1] + result[:addend2])
      end

      it 'ensures sum is at least twice the animal level' do
        result = subject.generate
        expect(result[:sum]).to be >= (animal.level * 2)
      end

      it 'includes the correct sum in the answers' do
        result = subject.generate
        expect(result[:answers]).to include(result[:sum])
      end

      it 'returns 3 possible answers' do
        result = subject.generate
        expect(result[:answers].size).to eq(3)
      end

      it 'returns unique answers' do
        result = subject.generate
        expect(result[:answers].uniq.size).to eq(3)
      end

      it 'ensures addends are within expected range' do
        result = subject.generate
        expect(result[:addend1]).to be_between(1, animal.level + 2)
        expect(result[:addend2]).to be_between(1, animal.level + 2)
      end

      it 'ensures wrong answers are within expected range' do
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

  context 'with controlled randomness' do
    let(:animal) { instance_double('Animal', level: 3) }

    before do
      allow(animal_chooser).to receive(:choose).and_return(animal)
      # Mock rand to control the output
      # First two calls are for addends
      # Next two are for wrong answers
      allow(subject).to receive(:rand).and_return(4, 5, 7, 10)
    end

    it 'generates expected puzzle with controlled randomness' do
      result = subject.generate

      expect(result[:addend1]).to eq(4)
      expect(result[:addend2]).to eq(5)
      expect(result[:sum]).to eq(9)

      # We know the answers will contain 9 (the sum)
      # and two other values (7 and 10 from our mocked rand)
      # The order might be different due to shuffle
      expect(result[:answers]).to contain_exactly(9, 7, 10)
    end
  end

  context 'edge cases' do
    context 'when sum is less than 3' do
      let(:animal) { instance_double('Animal', level: 1) }

      before do
        allow(animal_chooser).to receive(:choose).and_return(animal)
        # Force sum to be 2 (1+1)
        # Then provide wrong answers 1 and 3
        allow(subject).to receive(:rand).and_return(1, 1, 1, 3)
      end

      it 'uses correct lower bound for wrong answers' do
        result = subject.generate
        expect(result[:sum]).to eq(2)

        # For sum < 3, lower_bound should be 1
        wrong_answers = result[:answers] - [2]
        wrong_answers.each do |answer|
          expect(answer).to be_between(1, 5) # lower_bound = 1, upper_bound = 2 + 3
        end
      end
    end

    context 'when generating a puzzle with required sum' do
      let(:animal) { instance_double('Animal', level: 3) }

      before do
        allow(animal_chooser).to receive(:choose).and_return(animal)
      end

      it 'ensures the sum is at least twice the animal level' do
        result = subject.generate

        expect(result[:sum]).to be >= (animal.level * 2)
        expect(result[:addend1] + result[:addend2]).to eq(result[:sum])

        # Verify addends are within expected range
        expect(result[:addend1]).to be_between(1, animal.level + 2)
        expect(result[:addend2]).to be_between(1, animal.level + 2)

        # Verify answers include the correct sum
        expect(result[:answers]).to include(result[:sum])

        # Verify we have the right number of answers
        expect(result[:answers].size).to eq(3)

        # Verify all answers are unique
        expect(result[:answers].uniq.size).to eq(3)
      end
    end
  end
end
