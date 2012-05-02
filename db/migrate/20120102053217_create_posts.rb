class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title, :null => false
      t.text :body
      t.text :style
      t.text :meta_description
      t.text :meta_keywords
      t.string :slug, :null => false
      t.belongs_to :user, :null => false
      t.integer :status, :null => false, :default => 1
      t.boolean :private, :null => false, :default => false
      t.timestamps
    end
  end
end
