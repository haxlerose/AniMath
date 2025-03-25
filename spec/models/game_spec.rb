require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'columns' do
    it { should have_db_column(:name).of_type(:string) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:animals) }
  end

  describe 'callbacks' do
    it 'downcases the name before validation' do
      game = Game.new(name: 'CHESS')
      game.valid?
      expect(game.name).to eq('chess')
    end

    it 'does not modify name if it is nil' do
      game = Game.new
      expect { game.valid? }.not_to raise_error
    end
  end
end
