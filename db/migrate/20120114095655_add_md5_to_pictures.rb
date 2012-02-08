class AddMd5ToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :md5, :string
  end
end
