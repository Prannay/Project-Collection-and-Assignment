class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
   	  t.string   "title"
      t.string   "organization"
      t.text     "contact"
      t.text     "description"
      t.boolean  "oncampus"
      t.boolean  "islegacy"
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
    end
  end
end
