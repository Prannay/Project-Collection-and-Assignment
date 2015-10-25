class AddProjectDetailsToProjects < ActiveRecord::Migration
  def change
		add_column :projects, :iteration0, :string
		add_column :projects, :iteration1, :string
		add_column :projects, :iteration2, :string
		add_column :projects, :iteration3, :string
		add_column :projects, :iteration4, :string
		add_column :projects, :first_video, :string
		add_column :projects, :final_video, :string
		add_column :projects, :final_report, :string
		add_column :projects, :poster, :string
		add_column :projects, :source_code, :string
  end
end
