class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title,          null: false, default: ''
      t.string :slug,           null: false, default: ''
      t.text :body,             null: false, default: '', limit: 16_777_215
      t.text :style,            null: false, default: '', limit: 4_194_303
      t.text :meta_description, null: false, default: '', limit: 65535
      t.text :meta_keywords,    null: false, default: '', limit: 65535
      t.belongs_to :user,       null: false
      t.boolean :visible,       null: false, default: true
      t.boolean :sticky,        null: false, default: false
      t.string :tumblr_id
      t.timestamps
    end

    change_table :posts do |t|
      t.index :slug,      unique: true
      t.index :user_id
      t.index :visible
      t.index :sticky
      t.index :created_at
      t.index :updated_at
    end
  end
end
