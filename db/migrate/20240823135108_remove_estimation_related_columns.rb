class RemoveEstimationRelatedColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :plans, :usd_rate
  end
end
