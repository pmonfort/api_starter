# frozen_string_literal: true

class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
end
