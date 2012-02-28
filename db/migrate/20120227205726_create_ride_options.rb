class CreateRideOptions < ActiveRecord::Migration
  def change
    create_table :ride_options do |t|
      t.integer :passenger_count
      t.integer :cost
      t.string :meeting_place
      t.string :radio
      t.string :music
      t.string :smoking
      t.string :bikes
      t.text :message
      t.string :passengers
      t.integer :ride_id

      t.timestamps
    end
  end
end
