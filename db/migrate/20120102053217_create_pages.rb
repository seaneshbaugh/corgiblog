class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title,          null: false, default: ''
      t.string :slug,           null: false, default: ''
      t.text :body,             null: false, default: '', limit: 16_777_215
      t.text :style,            null: false, default: '', limit: 4_194_303
      t.text :meta_description, null: false, default: '', limit: 65535
      t.text :meta_keywords,    null: false, default: '', limit: 65535
      t.integer :order,         null: false, default: 0
      t.boolean :show_in_menu,  null: false, default: true
      t.boolean :visible,       null: false, default: true
      t.timestamps
    end

    change_table :pages do |t|
      t.index :slug,        unique: true
      t.index :order
      t.index :show_in_menu
      t.index :visible
      t.index :created_at
      t.index :updated_at
    end
  end
end
