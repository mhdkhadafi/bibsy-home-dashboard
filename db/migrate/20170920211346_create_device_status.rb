class CreateDeviceStatus < ActiveRecord::Migration[5.1]
  def change
    create_table :device_statuses do |t|
    	t.string :device              
      	t.string :status
    end
  end
end
