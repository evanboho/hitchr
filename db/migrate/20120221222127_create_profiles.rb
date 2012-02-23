class CreateProfiles < ActiveRecord::Migration
  
  def change
    create_table :profiles do |t|
      t.date :birthday
      t.string :sex
      t.string :home_town
      t.string :about_block
      t.float :latitude
      t.float :longitude
      t.integer :cred, :default => 0
      t.integer :user_id

      t.timestamps
    end
    
    add_index :profiles, :user_id
    
  end  
end
