class AddIndexToDeviceGroups < ActiveRecord::Migration[6.0]
  def change
    add_index :device_groups, :name
  end
end
