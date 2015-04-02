class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :organization
      t.text :contact
      t.text :description
      t.boolean :oncampus
      t.boolean :islegacy

      t.timestamps null: false
    end
  end
end
