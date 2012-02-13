class AddNicknameUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :users, :nickname, :unique => true
  end

  def down
    remove_index :users, :nickname
  end
end
