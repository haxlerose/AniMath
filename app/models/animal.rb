# frozen_string_literal: true

class Animal < ApplicationRecord
  has_and_belongs_to_many :games

  enum :group, %i[amphibian arachnid bird fish insect mammal reptile]
  enum :habitat, %i[air land sea]

  validates :name, presence: true
  validates :group, presence: true
  validates :habitat, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
