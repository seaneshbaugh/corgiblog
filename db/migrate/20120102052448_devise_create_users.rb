class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              :null => false, :default => '', :length => 254
      t.string :encrypted_password, :null => false, :default => ''
      t.string :first_name,         :null => false, :default => ''
      t.string :last_name,          :null => false, :default => ''
      t.string :phone_number
      t.string :role,               :null => false, :default => 'read_only'
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, :null => false, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.timestamps
    end

    change_table(:users) do |t|
      t.index :email, :unique => true
      t.index :first_name
      t.index :last_name
      t.index :phone_number
      t.index :role
      t.index :reset_password_token, :unique => true
      t.index :sign_in_count
      t.index :current_sign_in_ip
      t.index :last_sign_in_ip
      t.index :created_at
      t.index :updated_at
    end
  end
end
