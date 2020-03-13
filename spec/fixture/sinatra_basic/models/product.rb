# frozen_string_literal: true

# Product model
class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
end
