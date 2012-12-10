class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ''
      t.string :encrypted_password, :null => false, :default => ''
      t.string :role,               :null => false, :default => ''
      t.string :first_name,         :null => false, :default => ''
      t.string :last_name,          :null => false, :default => ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :null => false, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token

      t.timestamps
    end

    change_table :users do |t|
      t.index :email,                 :unique => true
      t.index :encrypted_password
      t.index :role
      t.index :first_name
      t.index :last_name
      t.index :reset_password_token,  :unique => true
      t.index :reset_password_sent_at
      t.index :remember_created_at
      t.index :sign_in_count
      t.index :current_sign_in_at
      t.index :last_sign_in_at
      t.index :current_sign_in_ip
      t.index :last_sign_in_ip
      t.index :authentication_token,  :unique => true
      t.index :created_at
      t.index :updated_at
    end
  end
end
