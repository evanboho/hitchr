class CreateRides < ActiveRecord::Migration
  
  def change
    create_table :rides do |t|
      t.string :origin
      t.string :originstate
      t.float :latitude
      t.float :longitude
      t.string :destination
      t.string :destinationstate
      t.float :bearing
      t.float :trip_distance
      t.datetime :datetime
      t.string :message
      t.integer :user_id

      t.timestamps
    end
    
    add_index :rides, :datetime
    add_index :rides, :origin
    add_index :rides, :user_id
    
  end
end
