class CreateResources < ActiveRecord::Migration[7.2]
  def change
    create_table :resources do |t|
      t.references :database_schema_model, null: false, foreign_key: true, type: :uuid
      t.references :plan, null: false, foreign_key: true, type: :uuid
      t.jsonb :show_options, null: false, default: {}
      t.jsonb :index_options, null: false, default: {}
      t.jsonb :update_options, null: false, default: {}
      t.jsonb :create_options, null: false, default: {}
      t.jsonb :destroy_options, null: false, default: {}

      t.timestamps
    end

    add_index :resources, [:database_schema_model_id, :plan_id], unique: true
  end
end
