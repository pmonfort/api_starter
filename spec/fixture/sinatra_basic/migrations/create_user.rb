# frozen_string_literal: true

# Create User migration
class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :password, null: false
      t.integer :age
      t.datetime :birthday, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
