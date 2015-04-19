class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :user, index: true
      t.references :team, index: true

      t.timestamps null: false
    end
    add_foreign_key :relationships, :users
    add_foreign_key :relationships, :teams

    add_index :relationships, [:user_id, :team_id], unique: true
  end
end
