class AssignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def download
    @assignments = []
    assign = Assignment.all
    i=1
    data = "SNo, Team, Project Title, Organization, Contact, Description, On Campus, Legacy SW\n"
    assign.each do |a|
      @project = Project.find_by(id: a.project_id)
      @team = Team.find_by(id: a.team_id)
      if @project.islegacy.to_s == "true"
        legacy="Yes"
      else
        legacy="No"
      end
      if @project.oncampus.to_s == "true"
        oncampus="Yes"
      else
        oncampus="No"
      end
      data << i.to_s << "," << @team.name.to_s.inspect << "," << @project.title << "," << @project.organization.to_s.inspect << "," << @project.contact.to_s.inspect << ","<< @project.description.to_s.inspect << "," << oncampus.to_s << "," << legacy.to_s << "\n"
      i+=1
    end
    date = Time.now.strftime("%Y%m")
    send_data data, filename: "project-assignment-#{date}.csv"
  end
  
  def assign
    teams = Team.all
    projects = Project.where("approved = ?", true)
    
    if teams.size > projects.size
      flash[:danger] = "Cannot proceed with Assignment Algorithm, Number of Teams more than number of Approved Projects"
      redirect_to viewassign_path
      return
    end
    
    nums = [teams.size, projects.size].max
    costMatrix = Array.new(nums){Array.new(nums)}

    numTeams = teams.size
    infiniteCost = nums*projects.size

    # Fill Cost Matrix with cost values
    for i in 0..(teams.size - 1)
      for j in 0..(projects.size - 1)
        pref = Preference.find_by(team_id: teams[i].id, project_id: projects[j].id)
        if pref and pref.value == 1
          costMatrix[i][j] = 1
        elsif pref and pref.value == -1
          costMatrix[i][j] = (2*numTeams) + 1
        else
          costMatrix[i][j] = numTeams + 1
        end
      end
    end

    # Fill in the padded rows with infinite cost value so that they are never assigned any project before others
    for i in teams.size..(nums - 1)
      for j in 0..(projects.size - 1)
        costMatrix[i][j] = infiniteCost
      end
    end
    
    # Call Munkres algorithm on the Cost Matrix
    m = Munkres.new(costMatrix)
    pairings = m.find_pairings
    
    numPos = 0
    numNeu = 0
    numNeg = 0
    Assignment.delete_all
    for i in 0..(pairings.size - 1)
      pair = pairings[i]
      if (pair[0] < teams.size)
        team = teams[pair[0]]
        project = projects[pair[1]]
        Assignment.create(team_id: team.id, project_id: project.id)
        pref = Preference.find_by(team_id: team.id, project_id: project.id)
        if pref and pref.value == 1
          numPos += 1
        elsif pref and pref.value == -1
          numNeg += 1
        else
          numNeu += 1
        end
      end
    end
    flash[:success] = "Assignment algorithm ran successfully, " + numPos.to_s + " teams got Positive preference, " + numNeu.to_s + " teams got Neutral preference, " + numNeg.to_s + " teams got Negative preference"
    redirect_to viewassign_path
  end

  def view
		@team_names = Array.new
		@project_names = Array.new
		Team.find_each do |team|
			@team_names << team.name
		end
		Project.find_each do |project|
			@project_names << project.title
		end

    @assignments = []
    assign = Assignment.all
    assign.each do |a|
      @project = Project.find_by(id: a.project_id)
      @team = Team.find_by(id: a.team_id)
        hash =  {  :project_id => @project.id, :team_id => @team.id, :project_title => @project.title, :team_name => @team.name }
       @assignments << hash
    end
  end

	def delete
		@assigned = Assignment.find_by_project_id(params[:project_id])
		@assigned.destroy
		flash[:success] = "Delete successful"
		redirect_to viewassign_path
	end

	def add
		team = Team.find_by_name(params[:team_name].to_s)
		team_assigned = Assignment.find_by_team_id(team.id)
		project = Project.find_by_title(params[:project_title].to_s)
		project_assigned = Assignment.find_by_project_id(project.id)
		if team_assigned != nil || project_assigned != nil
			flash[:error] = "Team or Project was already assigned"
			redirect_to viewassign_path
			return
		end
		assignment = Assignment.new
		assignment.team_id = Team.find_by_name(params[:team_name].to_s).id
		assignment.project_id = Project.find_by_title(params[:project_title].to_s).id
		assignment.save
		flash[:success] = "Successfully assigned project "+ params[:project_title].to_s+" to team "+params[:team_name].to_s
		redirect_to viewassign_path
	end

end
