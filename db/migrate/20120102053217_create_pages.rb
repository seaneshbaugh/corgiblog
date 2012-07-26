class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title,          :null => false, :default => ''
      t.text :body,             :null => false, :default => ''
      t.text :style,            :null => false, :default => ''
      t.text :meta_description, :null => false, :default => ''
      t.text :meta_keywords,    :null => false, :default => ''
      t.string :slug,           :null => false, :default => ''
      t.belongs_to :parent
      t.integer :display_order, :null => false, :default => 0
      t.integer :status,        :null => false, :default => 1
      t.boolean :private,       :null => false, :default => false
      t.timestamps
    end

    change_table :pages do |t|
      t.index :title,        :unique => true
      t.index :slug,         :unique => true
      t.index :parent_id
      t.index :display_order
      t.index :status
      t.index :private
      t.index :created_at
      t.index :updated_at
    end
  end
end
