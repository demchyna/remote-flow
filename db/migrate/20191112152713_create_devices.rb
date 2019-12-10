class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :token
      t.boolean :active, default: false

      t.timestamps
    end
    add_index :devices, :token
  end
end
