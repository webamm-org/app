class RemoveLeadsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :leads
  end
end
