class AddApprovedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :approved, :boolean, default: false
  end
end
