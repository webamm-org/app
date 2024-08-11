class CreateAuthentications < ActiveRecord::Migration[7.2]
  def change
    create_table :authentications, id: :uuid do |t|
      t.references :database_schema_model, null: false, foreign_key: true, type: :uuid
      t.references :plan, null: false, foreign_key: true, type: :uuid
      t.jsonb :options, default: {}, null: false

      t.timestamps
    end
  end
end
