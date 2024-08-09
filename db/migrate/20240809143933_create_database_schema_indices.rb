class CreateDatabaseSchemaIndices < ActiveRecord::Migration[7.1]
  def change
    create_table :database_schema_indices, id: :uuid do |t|
      t.references :database_schema_model, null: false, foreign_key: true, type: :uuid
      t.boolean :is_unique, null: false, default: false

      t.timestamps
    end

    create_table :database_schema_columns_indices, id: false do |t|
      t.belongs_to :database_schema_index, null: false, foreign_key: true, type: :uuid
      t.belongs_to :database_schema_column, null: false, foreign_key: true, type: :uuid
    end
  end
end
