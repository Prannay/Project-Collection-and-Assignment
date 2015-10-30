class TeamsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :destroy]
  before_action :valid_viewer, only: [:show]
  before_action :team_leader_or_admin,   only: [:destroy]
  before_action :team_leader, only: [:preference]

  def preference
    @team = current_user.is_member_of
    if @team
      @title = "Preference Selector"
      @projects = Project.where("approved = ?", true)
      render 'preference'
    else
      flash[:warning] = "You are not yet part of any team"
      redirect_to current_user
    end
  end

  def index
    if current_user.admin?
      @teams = Team.paginate(page: params[:page])
    else
      @team = current_user.is_member_of
      if @team 
        redirect_to @team
      else
        flash[:warning] = "You are not yet part of any team"
        redirect_to current_user
      end
    end
  end

  def new
  	@team = Team.new
  end

  def show
  	@team = Team.find(params[:id])
    @members = @team.members
  end
  
  def create
    if current_user.teams.count != 0
      flash[:danger] = "You have already created one team"
      redirect_to root_url
    else
  	  @team = Team.new(team_params)
  	  @team.user_id = current_user.id
  	  @team.code = ('a'..'z').to_a.shuffle.take(4).join()
      if @team.save
        current_user.join_team(@team)
        flash[:success] = "Team created Successfully"
        redirect_to @team
      else
        render 'new'
      end
    end
  end

  def edit
  	@team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = "Team updated"
      redirect_to @team
    else
      render 'edit'
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = "Team deleted"
    redirect_to root_url
  end
 
 private
    def team_params
      params.require(:team).permit(:name)
    end

    def team_leader
      @team = Team.find(params[:id])
      redirect_to root_url unless @team.is_leader?(current_user)
    end

    def team_leader_or_admin
      @team = Team.find(params[:id])
      redirect_to root_url unless @team.is_leader?(current_user) || current_user.admin?
    end

    def valid_viewer
      @team = Team.find(params[:id])
      redirect_to root_url unless current_user.is_member?(@team) || current_user.admin?
    end
end
