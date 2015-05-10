class RemoveNameFromPreassignments < ActiveRecord::Migration
  def change
    remove_column :preassignments, :name_string, :string
  end
end
