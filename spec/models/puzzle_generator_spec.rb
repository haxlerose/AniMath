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

      it 'ensures result is at least twice the animal level' do
        result = subject.generate
        expect(result[:result]).to be >= (animal.level * 2)
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

      it 'ensures num1 and num2 are within expected range' do
        result = subject.generate
        expect(result[:num1]).to be_between(1, animal.level + 2)
        expect(result[:num2]).to be_between(1, animal.level + 2)
      end

      it 'ensures wrong answers are within expected range' do
        result = subject.generate
        correct_result = result[:result]
        wrong_answers = result[:answers] - [correct_result]

        lower_bound = correct_result < 3 ? 1 : (correct_result - 2)
        upper_bound = correct_result + 3

        wrong_answers.each do |answer|
          expect(answer).to be_between(lower_bound, upper_bound)
        end
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

          lower_bound = correct_result < 3 ? 1 : (correct_result - 2)
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

      it 'ensures the result is at least twice the animal level' do
        result = subject.generate

        expect(result[:result]).to be >= (animal.level * 2)
        expect(result[:num1] + result[:num2]).to eq(result[:result])

        # Verify num1 and num2 are within expected range
        expect(result[:num1]).to be_between(1, animal.level + 2)
        expect(result[:num2]).to be_between(1, animal.level + 2)

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
