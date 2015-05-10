class PreassignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  @@teamn=Team.new
  @@project=Project.new
  @@pre_projects = Project.where("approved = ?", false)

  def new
    @preassignment = Preassignment.new
  end
  
  def show
    @title = "Preassign Project for Team"
    @pre_projects = @@pre_projects
    @team=@@teamn
  end
  
  def view
    if params[:projname]
      @@project = @@pre_projects[params[:projname][:value].to_i]
      @project = @@project
      @team = @@teamn
      if @team.name
        @preassign = Preassignment.new do |p|
          p.team_id = @team.id
          p.project_id = @project.id
        end
        if @preassign.save
          pre=Preassignment.all
          pre.each do |p|
            puts p.project_id
            puts p.team_id
          end
          flash[:success] = "Team \"" + @team.name + "\" has been preassigned project \"" +  @project.title + "\""
          redirect_to '/preassignment'
        else
          render 'new'
        end
      else
        flash[:danger] = "Please select team name"
        redirect_to '/preassign'
      end
    else
      flash[:danger] = "Please select project name"
      redirect_to '/preassignment'
    end
  end
  
  def create
    @@teamn = Team.find_by(name: params[:teamname][:name])
    if @@teamn
      redirect_to '/preassignment'
    else
      flash[:danger] = "Please give correct team name"
      redirect_to '/preassign'
    end
  end
  
  def preassignment_params
    params.require(:preassignment).permit(:team_id, :project_id)
  end
end
