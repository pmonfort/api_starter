# frozen_string_literal: true

class Product < ApplicationRecord
  validates :first_day_on_market, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true
end
