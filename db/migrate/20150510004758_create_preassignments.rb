class CreatePreassignments < ActiveRecord::Migration
  def change
    create_table :preassignments do |t|
      t.integer :team_id
      t.integer :project_id
      t.string :name

      t.timestamps null: false
    end
  end
end
