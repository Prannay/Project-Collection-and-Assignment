class ProjectsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :approve, :unapprove, :approved, :unapproved, :toggle]
  before_action :admin_user,     only: [:index, :edit, :update, :destroy, :approve, :unapprove, :unapproved, :toggle]

  def index
    @title = "All Projects"
    @projects = Project.paginate(page: params[:page])
  end
  
  def approved
    @title = "Approved Projects"
    @projects = Project.where("approved = ?", true).paginate(page: params[:page])
    render 'index'
  end

  def unapproved
    @title = "Unapproved Projects"
    @projects = Project.where("approved = ?", false).paginate(page: params[:page])
    render 'index'
  end

  def show
    @project = Project.find(params[:id])
    if !current_user.admin? && !@project.approved?
      flash[:danger] = "You do not have priviledge to view this project"
      redirect_to approved_projects_url
    end
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

  def approve
    project = Project.find_by(id: params[:id])
    if project
      if project.approved?
        flash[:info] = "Project already approved"
        redirect_to projects_url
      else
        project.approved = true
        project.save
        flash[:success] = "Project approved successfully"
        redirect_to projects_url
      end
    else
      flash[:danger] = "Project does not exist"
      redirect_to root_url
    end
  end
  
  def unapprove
    project = Project.find_by(id: params[:id])
    if project
      if !project.approved?
        flash[:info] = "Project already unapproved"
        redirect_to projects_url
      else
        project.approved = false
        project.save
        flash[:success] = "Project unapproved successfully"
        redirect_to projects_url
      end
    else
      flash[:danger] = "Project does not exist"
      redirect_to root_url
    end
  end

  def toggle
    @project = Project.find(params[:id])
    @project.toggle(:approved)
    @project.save
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.js
    end
  end

  private
      def project_params
        if current_user.admin?
          params.require(:project).permit(:title, :organization, :contact, :description, :oncampus, :islegacy, :approved)
        else
          params.require(:project).permit(:title, :organization, :contact, :description, :oncampus, :islegacy)
        end
    end
end
