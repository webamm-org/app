class CreateLeads < ActiveRecord::Migration[7.2]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :email, null: false

      t.timestamps
    end

    add_index :leads, :email, unique: true
  end
end
