class AssignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def assign
  	@teams = Team.all
  	@projects = Project.where("approved = ?", true)

  	@graph = Array.new(@teams.size){Array.new(@projects.size)}
  	for i in 0..(@teams.size - 1)
  	  for j in 0..(@projects.size - 1)
  	  	pref = Preference.find_by(team_id: @teams[i].id, project_id: @projects[j].id)
  	  	if pref
  	  		@graph[i][j] = pref.value
  	  	else
  	  		@graph[i][j] = 0
  	  	end
  	  end
  	end
  	    
    @count, @matching = project_assignment(@graph)
  end

  private
	#   In this program, we will match the student groups with the projects as per their provided preferences as top or bottom project.
	def check_eligibility(graph,visited,group_no,final_matchings, case_value)
	  for j in 0..graph[0].size
		if(graph[group_no][j] == case_value && visited[j] == false)
		  visited[j] = true
		  if(final_matchings[j] ==-1 || check_eligibility(graph,visited,final_matchings[j] ,final_matchings, case_value) )
		    final_matchings[j] = group_no
		    return true
		  end
	    end
	  end
	  return false
    end

    def project_assignment(graph)
      no_of_groups = graph.size
      no_of_projects = graph[0].size   

      #Assignment Phase 1 :  Maximum Matching for Top Projects
      #Initializing Jobs. -1 stands for unassigned
      final_matchings  = Array.new(no_of_projects, -1)
      matching_count = 0

      for i in 0..(no_of_groups-1)
   	    #Initializing  project checked array
   	    visited = Array.new(no_of_projects,false)
   	    #Checking if the group i wants the project
   	    if(check_eligibility(graph,visited, i , final_matchings,1))
   		  matching_count +=1
   	    end
      end

      #Assignment Phase 2 :  Assigning Neutral Projects
      #=begin
      if matching_count<no_of_groups
	    remaining_groups = [  ]
	    for i in 0..no_of_groups-1
          if( !final_matchings.include? i)
		    remaining_groups << i
		  end
	    end
        puts "Remaining Team after Top Matching: #{remaining_groups}"		
  	
        for i in remaining_groups
  	      visited = Array.new(no_of_projects,false)
  		  if(check_eligibility(graph,visited,i,final_matchings,0))
  		    matching_count +=1
  		  end
	    end
      end

      #Assignment Phase 3 :  Assigning Bottom Projects [ Worst case scenario]
      #=begin
      if matching_count<no_of_groups
	    for i in remaining_groups.size
		  if( final_matchings.include? i)
		    remaining_groups.delete(i)
		  end
	    end

  	    for i in remaining_groups
		  for j in 0..no_of_projects-1
		    # The Project is in Bottom 5 and the project is not has been 
		    if( graph[i][j] == -1 && final_matchings[ j] == -1)
		      final_matchings[ j ] =i
		      matching_count +=1
		    end 
		  end
	    end
	  end
	  return matching_count, final_matchings
    end

end
