class ProjectsController < ApplicationController
  def new
  	@project = Project.new
  end

  def show
  	@project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)
    if @project.save
       flash[:success] = "Project Added for Approval"
       redirect_to @project
    else
      render 'new'
    end
  end
  
  private
      def project_params
      params.require(:project).permit(:title, :organization, :contact, :description, :oncampus, :islegacy)
    end
end
