class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.references :team, index: true
      t.references :project, index: true

      t.timestamps null: false
    end
    add_foreign_key :preferences, :teams
    add_foreign_key :preferences, :projects
    add_index :preferences, [:team_id, :project_id], unique: true

  end
end
