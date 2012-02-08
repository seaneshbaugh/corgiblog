class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :title, :null => false
      t.text :body
      t.text :style
      t.text :meta_description
      t.text :meta_keywords
      t.string :slug, :null => false
      t.belongs_to :parent
      t.integer :display_order, :null => false, :default => 0
      t.integer :status, :null => false, :default => 1
      t.boolean :private, :null => false, :default => false
      t.timestamps
    end
  end
end
