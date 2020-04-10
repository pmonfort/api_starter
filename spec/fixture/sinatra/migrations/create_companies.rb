# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :web_site

      t.timestamps
    end

    add_index :companies, :name, unique: true
  end
end
