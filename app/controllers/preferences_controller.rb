class PreferencesController < ApplicationController
  before_action :logged_in_user
  before_action :team_leader, only: [:create]

  def create
    @team = Team.find_by(user_id: current_user.id)
    @project = Project.find_by(id: params[:project_id])
    @pref = Preference.find_by(team_id: @team.id, project_id: @project.id)
    if @pref
      @pref.value = params[:preference][:value]
      @pref.save
    else
      Preference.create(team_id: @team.id, project_id: @project.id, value: params[:preference][:value])
    end
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.js
    end
  end

 private
    def team_leader
      @team = Team.find_by(user_id: current_user.id)
      redirect_to root_url unless @team.is_leader?(current_user)
    end
end
