class ProjectsController < ApplicationController
  def new
  	@project = Project.new
  end

  def show
  	@project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  private
      def project_params
      params.require(:project).permit(:title, :organization, :contact, :description, :oncampus, :islegacy)
    end
end
