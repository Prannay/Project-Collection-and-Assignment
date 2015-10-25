class UsersController < ApplicationController
  before_action :logged_in_user, only: 
[:index, :show, :edit, :update, :upload, :destroy,
 :iteration0, :iteration1, :iteration2, :iteration3, :iteration4, :poster, :first_video, :final_video,
 :final_report, :project, :filename]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: [:index, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
       log_in @user
       flash[:success] = "Welcome to the ProjectApp"
       redirect_to @user
    else
       render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

	def project
		@user = User.find(params[:user_id])

		if !have_permission? 
			return 
		end
		@relationship = Relationship.find_by_user_id(params[:user_id])
		if !have_team?
			return
		end
		@team = Team.find(@relationship.team_id)
		@assignment = Assignment.find_by_team_id(@team.id)
		if !have_project?
			return
		end
		@project = Project.find(@assignment.project_id)
		@member_ids = Relationship.where(team_id: @team.id).all
		@members = Array.new
		@member_ids.each do |member|
			tmp = User.find(member.user_id.to_i)
			@members << tmp.name.to_s
		end
	end

	def upload
		@user = User.find(params[:user_id])

		if !current_user?(@user) 
			flash[:warning] = "You have no right"
			redirect_to current_user
			return
		end
		@relationship = Relationship.find_by_user_id(params[:user_id])
		@team = Team.find(@relationship.team_id)
		@assignment = Assignment.find_by_team_id(@team.id)
		@project = Project.find(@assignment.project_id)

		iteration0 = params[:iteration0]
		iteration1 = params[:iteration1]
		iteration2 = params[:iteration2]
		iteration3 = params[:iteration3]
		iteration4 = params[:iteration4]
		poster = params[:poster]
		first_video = params[:first_video]
		final_video = params[:final_video]
		final_report = params[:final_report]

		if iteration0 != nil
			@project.iteration0 = iteration0.original_filename.to_s
			upload_file(iteration0)
		end
		if iteration1 != nil
			@project.iteration1 = iteration1.original_filename.to_s
			upload_file(iteration1)
		end
		if iteration2 != nil
			@project.iteration2 = iteration2.original_filename.to_s
			upload_file(iteration2)
		end
		if iteration3 != nil
			@project.iteration3 = iteration3.original_filename.to_s
			upload_file(iteration3)
		end
		if iteration4 != nil
			@project.iteration4 = iteration4.original_filename.to_s
			upload_file(iteration4)
		end
		if poster != nil
			@project.poster = poster.original_filename.to_s
			upload_file(poster)
		end
		if first_video != nil
			@project.first_video = first_video.original_filename.to_s
			upload_file(first_video)
		end
		if final_video != nil
			@project.final_video = final_video.original_filename.to_s
			upload_file(final_video)
		end
		if final_report != nil
			@project.final_report = final_report.original_filename.to_s
			upload_file(final_report)
		end
		@project.save
		
		redirect_to user_project_path(params[:user_id])
	end

	def download
		@user = User.find(params[:user_id])

		if !current_user?(@user) 
			flash[:warning] = "You have no right"
			redirect_to current_user
			return
		end
		@relationship = Relationship.find_by_user_id(params[:user_id])
		if !have_team?
			return
		end
		@team = Team.find(@relationship.team_id)

		filename = params[:filename]
		send_file("./public/uploads/"+@team.id.to_s+"/"+filename.to_s, :filename => filename.to_s, :type => "application/pdf")
	end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

	def admin_download
		admin_user
		
		@user = User.find(params[:user_id])
		@relationship = Relationship.find_by_user_id(params[:user_id])
		team_id = @relationship.team_id
		cmd = "tar czf ./public/uploads/"+team_id.to_s+".tar.gz"+" ./public/uploads/"+team_id.to_s
		system(cmd)
		send_file("./public/uploads/"+team_id.to_s+".tar.gz", :filename => team_id.to_s+".tar.gz", :type => "application/x-tar")
	end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
