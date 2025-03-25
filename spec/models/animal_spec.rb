require 'rails_helper'

RSpec.describe Animal, type: :model do
  describe 'columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:level).of_type(:integer) }
    it { should have_db_column(:group).of_type(:integer) }
    it { should have_db_column(:habitat).of_type(:integer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:level) }
    it { should validate_presence_of(:group) }
    it { should validate_presence_of(:habitat) }
    it { should validate_numericality_of(:level).only_integer.is_greater_than(0) }
  end

  describe 'enums' do
    it {
      should define_enum_for(:group).with_values(amphibian: 0, arachnid: 1, bird: 2, fish: 3, insect: 4, mammal: 5,
                                                 reptile: 6)
    }
    it { should define_enum_for(:habitat).with_values(air: 0, land: 1, sea: 2) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:games) }
  end
end
