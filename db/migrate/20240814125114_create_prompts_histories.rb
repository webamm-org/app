class CreatePromptsHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :prompts_histories do |t|
      t.references :plan, null: false, foreign_key: true, type: :uuid
      t.boolean :failed, default: false
      t.text :prompt, null: false
      t.text :llm_waml

      t.timestamps
    end
  end
end
