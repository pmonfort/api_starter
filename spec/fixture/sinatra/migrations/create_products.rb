# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.datetime :first_day_on_market, null: false
      t.string :name, null: false
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
