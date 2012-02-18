class CreateRides < ActiveRecord::Migration
  
  def change
    create_table :rides do |t|
      t.string :origin
      t.string :originstate
      t.string :destination
      t.string :destinationstate
      t.date :date
      t.time :time
      t.string :message
      t.integer :user_id

      t.timestamps
    end
    
    add_index :rides, :date
    add_index :rides, :origin
    
  end
end
