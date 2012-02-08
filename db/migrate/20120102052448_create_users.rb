class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email_address, :null => false
      t.string :password_hash, :null => false
      t.string :password_salt, :null => false
      t.string :remember_me_token
      t.string :password_reset_token
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :ip_addresses
      t.integer :privilege_level, :null => false, :default => 1
      t.integer :login_count, :null => false, :default => 0
      t.integer :post_count, :null => false, :default => 0
      t.datetime :password_reset_sent_at
      t.datetime :last_login
      t.timestamps
    end
  end
end
