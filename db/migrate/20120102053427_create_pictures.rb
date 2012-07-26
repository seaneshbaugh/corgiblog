class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.text :title,               :null => false, :default => ''
      t.text :alt_text,            :null => false, :default => ''
      t.text :caption,             :null => false, :default => ''
      t.attachment :image
      t.string :image_fingerprint
      t.timestamps
    end

    change_table :pictures do |t|
      t.index :image_file_name
      t.index :image_content_type
      t.index :image_file_size
      t.index :image_fingerprint
      t.index :created_at
      t.index :updated_at
    end
  end
end