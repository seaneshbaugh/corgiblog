class AddStickyToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :sticky, :boolean, after: :visible, null: false, default: false

    add_index :posts, :sticky
  end
end
