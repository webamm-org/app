class AddAiEnabledToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :ai_enabled, :boolean, default: false
  end
end
