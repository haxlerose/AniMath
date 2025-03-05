# frozen_string_literal: true

class Game < ApplicationRecord
  has_and_belongs_to_many :animals

  validates :name, presence: true, uniqueness: true

  before_validation :downcase_name

  private

  def downcase_name
    self.name = name.downcase if name.present?
  end
end
