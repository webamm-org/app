class CreateDatabaseSchemaAssociations < ActiveRecord::Migration[7.1]
  def change
    create_table :database_schema_associations, id: :uuid do |t|
      t.integer :connection_type, null: false, default: 0
      t.jsonb :connection_options, default: {}, null: false
      t.references :source_database_schema_model, null: false, foreign_key: { to_table: :database_schema_models }, type: :uuid
      t.references :destination_database_schema_model, null: true, foreign_key: { to_table: :database_schema_models }, type: :uuid

      t.timestamps
    end
  end
end
