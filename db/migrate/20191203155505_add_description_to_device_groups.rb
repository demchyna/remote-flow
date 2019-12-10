class AddDescriptionToDeviceGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :device_groups, :description, :text
  end
end
