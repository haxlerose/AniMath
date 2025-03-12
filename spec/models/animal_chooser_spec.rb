# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnimalChooser do
  let(:game) { instance_double('Game') }
  let(:animal1) { instance_double('Animal', level: 1) }
  let(:animal2) { instance_double('Animal', level: 1) }
  let(:animal3) { instance_double('Animal', level: 2) }
  let(:animal4) { instance_double('Animal', level: 3) }
  let(:all_animals) { [animal1, animal2, animal3, animal4] }

  subject { described_class.new(game) }

  describe '#initialize' do
    it 'initializes with a game' do
      expect(subject.instance_variable_get(:@game)).to eq(game)
    end
  end

  describe '#choose' do
    before do
      allow(Animal).to receive(:all).and_return(all_animals)
    end

    context 'when no animals are available' do
      before do
        allow(game).to receive(:animals).and_return(all_animals)
      end

      it 'returns nil' do
        expect(subject.choose).to be_nil
      end
    end

    context 'when some animals are available' do
      before do
        allow(game).to receive(:animals).and_return([animal3, animal4])
      end

      it 'selects from animals not in the game' do
        expect([animal1, animal2]).to include(subject.choose)
      end

      it 'selects animals with the minimum level' do
        # Both animal1 and animal2 have level 1, which is the minimum
        expect(subject.choose.level).to eq(1)
      end
    end

    context 'when all animals are available' do
      before do
        allow(game).to receive(:animals).and_return([])
      end

      it 'selects from all animals with the minimum level' do
        chosen_animal = subject.choose
        expect(chosen_animal.level).to eq(1)
        expect([animal1, animal2]).to include(chosen_animal)
      end
    end

    context 'with a mixed selection of animals' do
      let(:game_animals) { [animal1, animal3] }

      before do
        allow(game).to receive(:animals).and_return(game_animals)
      end

      it 'selects from remaining animals with the minimum level' do
        # animal2 is the only level 1 animal not in the game
        expect(subject.choose).to eq(animal2)
      end
    end

    context 'with single animals at each level' do
      let(:modified_animals) { [animal1, animal3, animal4] } # Only one level 1 animal

      before do
        allow(Animal).to receive(:all).and_return(modified_animals)
        allow(game).to receive(:animals).and_return([animal3]) # Level 2 is in the game
      end

      it 'selects the lowest level animal available' do
        expect(subject.choose).to eq(animal1)
      end
    end

    context 'randomness in selection' do
      before do
        allow(game).to receive(:animals).and_return([])
        # We have two level 1 animals (animal1 and animal2)
        # Mock sample to test the randomness
        allow_any_instance_of(Array).to receive(:sample).and_return(animal2)
      end

      it 'uses sample to randomly select from animals of the minimum level' do
        expect(subject.choose).to eq(animal2)
      end
    end
  end
end
