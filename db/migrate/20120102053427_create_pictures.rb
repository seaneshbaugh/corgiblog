class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.text :title,                    null: false, default: '', limit: 65535
      t.text :alt_text,                 null: false, default: '', limit: 65535
      t.text :caption,                  null: false, default: '', limit: 65535
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.string :image_fingerprint
      t.integer :image_original_width,  null: false, default: 1
      t.integer :image_original_height, null: false, default: 1
      t.integer :image_medium_width,    null: false, default: 1
      t.integer :image_medium_height,   null: false, default: 1
      t.integer :image_small_width,     null: false, default: 1
      t.integer :image_small_height,    null: false, default: 1
      t.integer :image_thumb_width,     null: false, default: 1
      t.integer :image_thumb_height,    null: false, default: 1
      t.datetime :image_updated_at
      t.timestamps
    end

    change_table :pictures do |t|
      t.index :image_file_name
      t.index :image_content_type
      t.index :image_fingerprint
      t.index :image_updated_at
      t.index :created_at
      t.index :updated_at
    end
  end
end
