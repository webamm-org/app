# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
