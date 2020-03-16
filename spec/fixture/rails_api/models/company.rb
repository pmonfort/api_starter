# frozen_string_literal: true

class Company < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
end
