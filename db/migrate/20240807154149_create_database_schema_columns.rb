class CreateDatabaseSchemaColumns < ActiveRecord::Migration[7.1]
  def change
    create_table :database_schema_columns, id: :uuid do |t|
      t.references :database_schema_model, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.integer :field_type, null: false, default: 0
      t.boolean :can_be_null, null: false, default: false
      t.string :default_value
      t.jsonb :options, null: false, default: {}

      t.timestamps
    end

    add_index :database_schema_columns, [:database_schema_model_id, :name], unique: true
  end
end
