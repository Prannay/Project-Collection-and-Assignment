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
      @preproj = Preassignment.find_by(project_id: @project.id)
      if(@preproj)
        flash[:danger] = "Project \'#{@project.title}\' already preassigned. Please select different project"
        redirect_to '/preassignment'
      else
        @team = @@teamn
        if @team.name
					@preteam = Preassignment.find_by(team_id: @team.id)
					if(@preteam)
            @preteam.project_id = @project.id
            if @preteam.save
              flash[:success] = "Team \"" + @team.name + "\" has been updated with preassigned project \"" +  @project.title + "\""
              redirect_to '/preassignment'
            else
              flash.now[:danger] = "Some problem occured while saving to database"
              render 'new'
            end
          else
            @preassign = Preassignment.new do |p|
							p.team_id = @team.id
							p.project_id = @project.id
						end
						if @preassign.save
							flash[:success] = "Team \"" + @team.name + "\" has been preassigned project \"" +  @project.title + "\""
							redirect_to '/preassignment'
						else
							flash.now[:danger] = "Some problem occured while saving to database"
							render 'new'
						end
					end #preteam
				else
					flash.now[:danger] = "Please select team name"
					render 'new'
				end #team name
			end	#preproj
		else
			flash[:danger] = "Please select project name"
			redirect_to '/preassignment'
		end #proj
  end #def
  
  def create
    @@teamn = Team.find_by(name: params[:teamname][:name])
    if @@teamn
      redirect_to '/preassignment'
    else
      flash.now[:danger] = "Please give correct team name"
      render 'new'
    end
  end
  
  def preassignment_params
    params.require(:preassignment).permit(:team_id, :project_id)
  end
end
