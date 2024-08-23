class RemoveAiRelatedColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :plans, :ai_enabled
    remove_column :plans, :started
    remove_column :users, :ai_enabled
  end
end
