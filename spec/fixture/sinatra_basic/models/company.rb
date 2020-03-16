# frozen_string_literal: true

class Company < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
end
