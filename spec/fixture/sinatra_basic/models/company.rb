# frozen_string_literal: true

# Company model
class Company < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
end
