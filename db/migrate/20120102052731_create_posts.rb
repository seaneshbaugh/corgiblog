class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title,          :null => false, :default => ''
      t.text :body,             :null => false, :default => ''
      t.text :style,            :null => false, :default => ''
      t.text :meta_description, :null => false, :default => ''
      t.text :meta_keywords,    :null => false, :default => ''
      t.string :slug,           :null => false, :default => ''
      t.belongs_to :user,       :null => false
      t.integer :status,        :null => false, :default => 1
      t.boolean :private,       :null => false, :default => false
      t.string :tumblr_id
      t.timestamps
    end

    change_table :posts do |t|
      t.index :title,     :unique => true
      t.index :slug,      :unique => true
      t.index :user_id
      t.index :status
      t.index :private
      t.index :tumblr_id, :unique => true
      t.index :created_at
      t.index :updated_at
    end
  end
end
