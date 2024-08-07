class CreateDatabaseSchemaModels < ActiveRecord::Migration[7.1]
  def change
    create_table :database_schema_models, id: :uuid do |t|
      t.string :name, null: false
      t.references :plan, null: false, foreign_key: true, type: :uuid
      t.text :description
      t.jsonb :options, null: false, default: {}

      t.timestamps
    end

    add_index :database_schema_models, %i[plan_id name], unique: true
  end
end
