class AddCodeToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :code, :string
  end
end
