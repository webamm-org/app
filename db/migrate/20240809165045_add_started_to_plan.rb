class AddStartedToPlan < ActiveRecord::Migration[7.1]
  def change
    add_column :plans, :started, :boolean, default: false
  end
end
