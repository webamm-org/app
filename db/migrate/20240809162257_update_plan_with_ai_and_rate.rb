class UpdatePlanWithAiAndRate < ActiveRecord::Migration[7.1]
  def change
    add_column :plans, :ai_enabled, :boolean, default: false
    add_column :plans, :usd_rate, :integer, default: 0
  end
end
