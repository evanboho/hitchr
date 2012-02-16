class CreateRides < ActiveRecord::Migration
  
  def change
    create_table :rides do |t|
      t.string :origin
      t.string :destination
      t.date :date
      t.time :time
      t.string :message
      t.integer :user_id

      t.timestamps
    end
    add_index :rides, [:origin, :destination, :date]
  end
end
