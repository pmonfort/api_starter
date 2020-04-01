# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :age
      t.datetime :birthday, null: false
      t.references :company, null: false, foreign_key: true
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.string :password, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
