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

        def list_all_users_peer_evaluation
                @all_pe = []
                all_users = User.all
                all_users.each do |user|
                        if user.admin?
                                next
                        end

                        user_pe = []
                        user_pe << user.name

                        # get team name
                        team = user.is_member_of
                        if (team.nil?)
                                user_pe << ""
                                user_pe << ""
                                user_pe << ""
                                user_pe << user.id
                                user_pe << -1
                        else
                                user_pe << team.name

                                score = 0
                                comment = []
                                members = team.members
                                members.each do |member|
                                        member_record = User.find_by(id: member.id)
                                        pe = member_record.peer_evaluation
                                        if (not pe.nil?) and (not pe.empty?) and pe.has_key?(user.id.to_s)
                                                if pe[user.id.to_s].has_key?("score")
                                                        score += pe[user.id.to_s]["score"].to_i
                                                end
                                                if pe[user.id.to_s].has_key?("comment")
                                                        comment << pe[user.id.to_s]["comment"]
                                                end
                                        end
                                end

                                comment_str = ""
                                comment.each_with_index do |c, i|
                                        comment_str += c
                                        if i < comment.size - 1
                                                comment_str += " <br\> "
                                        end
                                end

                                user_pe << score
                                user_pe << comment_str

                                user_pe << user.id
                                user_pe << team.id
                        end

                        @all_pe << user_pe
                end

                p "###########"
                p @all_pe

                render 'all_users_peer_evaluation'
        end

        def list_team_peer_evaluation
                @team = Team.find_by(id: params["check_team_peer_evaluation"].to_i)
                if @team.nil?
                        flash.now[:danger] = "Can't find the team"
                        redirect_to :back
                        return
                end

                render 'team_peer_evaluation'
        end

        def do_peer_evaluation
                if (current_user.admin? and params.has_key?("check_team_peer_evaluation"))
                        list_team_peer_evaluation
                        return
                end

                if (not current_user.admin?) or (current_user.admin? and params.has_key?("check_one_user_peer_evaluation"))
                        the_user_id = -1
                        if (current_user.admin? and params.has_key?("check_one_user_peer_evaluation"))
                                the_user_id = params["check_one_user_peer_evaluation"].to_i
                        else
                                the_user_id = current_user.id
                        end

                        @current_pe = {}
                        if @last_pe_submission.nil? or @last_pe_submission.empty?
                                p "hahaha", the_user_id
                                user = User.find_by(id: the_user_id)
                                @current_pe = user.peer_evaluation
                        else
                                @current_pe = @last_pe_submission
                        end

                        p "*******************************"
                        p @current_pe

                        # @title = "Unapproved Projects"
                        the_user = User.find_by(id: the_user_id)
                        p the_user
                        p "*******************************"
                        @team = the_user.is_member_of
                        p @team
                        if @team.nil?
                                flash.now[:danger] = "Can't find your team"
                                @title = "Approved Projects"
                                @projects = Project.where("approved = ?", true).paginate(page: params[:page])
                                render 'home'
                                return
                        end
                        @members = @team.members
                        render 'peer_evaluation'
                        return
                end

                list_all_users_peer_evaluation
        end

        def submit_peer_evaluation
                if not params.has_key?(:peer_evaluation)
                        flash.now[:danger] = 'The content of peer evaluation is missing.'
                        do_peer_evaluation
                        return
                end

                result = {}

                params[:peer_evaluation].each do |key, value|
                        key_list = key.split(".")
                        if not result.has_key?(key_list[0])
                                result[key_list[0]] = {key_list[1] => value}
                        else
                                if result[key_list[0]].empty?
                                        result[key_list[0]] = {}
                                end
                                result[key_list[0]][key_list[1]] = value
                        end
                end

                @last_pe_submission = result

                score_sum = 0
                result.each do |key, value|
                        if value.has_key?("score")
                                score_sum += value["score"].to_i
                        end
                end

                if score_sum != 80
                        flash.now[:danger] = 'The scores summary is not equal to 80.'
                        do_peer_evaluation
                        return
                end


                user = User.find_by(id: current_user.id)
                user.peer_evaluation = result
                user.save!

                flash.now[:success] = 'Peer evaluation results have been saved.'
                do_peer_evaluation
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
                        current_user.owns.create(project_id: @project.id)
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
                if current_user && current_user.admin?
                        params.require(:project).permit(:title, :organization, :contact, :description, :oncampus, :islegacy, :approved)
                else
                        params.require(:project).permit(:title, :organization, :contact, :description, :oncampus, :islegacy)
                end
        end
end
