class ProjectsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :admin_user,     only: [:edit, :update, :destroy]

  def index
    @projects = Project.paginate(page: params[:page])
  end
  
  def show
    @project = Project.find(params[:id])
  end

  def new
  	@project = Project.new
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

  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(project_params)
      flash[:success] = "Project details updated"
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    flash[:success] = "Project deleted"
    redirect_to projects_url
  end

  private
      def project_params
      params.require(:project).permit(:title, :organization, :contact, :description, :oncampus, :islegacy)
    end
end
