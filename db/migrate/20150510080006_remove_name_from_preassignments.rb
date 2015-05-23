class RemoveNameFromPreassignments < ActiveRecord::Migration
  def change
    remove_column :preassignments, :name, :string
  end
end
