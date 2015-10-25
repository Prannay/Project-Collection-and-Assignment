module SessionsHelper

        # Logs in the given user.
        def log_in(user)
			if ApplicationController::CAS_ENABLED
				puts "!! login now"
				@username = session[:cas_user]
				@login_url = CASClient::Frameworks::Rails::Filter.login_url(self)
				session[:user_id] = @username
			else
				session[:user_id] = user.id
			end
        end

        # Remembers a user in a persistent session.
        def remember(user)
                user.remember
                cookies.permanent.signed[:user_id] = user.id
                cookies.permanent[:remember_token] = user.remember_token
        end

        # Returns true if the given user is the current user.
        def current_user?(user)
                user == current_user
        end

        # Returns the current logged-in user (if any).
        def current_user
                if (user_id = session[:user_id])
                        @current_user ||= User.find_by(id: user_id)
                elsif (user_id = cookies.signed[:user_id])
                        #raise       # The tests still pass, so this branch is currently untested.
                        user = User.find_by(id: user_id)
                        if user && user.authenticated?(cookies[:remember_token])
                                log_in user
                                @current_user = user
                        end
                end
        end

        # Returns true if the user is logged in, false otherwise.
        def logged_in?
                !current_user.nil?
        end

        # Forgets a persistent session.
        def forget(user)
                user.forget
                cookies.delete(:user_id)
                cookies.delete(:remember_token)
        end

        # Logs out the current user.
        def log_out
                forget(current_user)
                session.delete(:user_id)
                @current_user = nil
        end

        # Redirects to stored location (or to the default).
        def redirect_back_or(default)
                redirect_to(session[:forwarding_url] || default)
                session.delete(:forwarding_url)
        end

        # Stores the URL trying to be accessed.
        def store_location
                session[:forwarding_url] = request.url if request.get?
        end

        # Confirms a logged-in user.
        def logged_in_user
                unless logged_in?
                        store_location
                        flash[:danger] = "Please log in."
                        redirect_to login_url
                end
        end

        # Confirms the correct user.
        def correct_user
                @user = User.find(params[:id])
                redirect_to(root_url) unless current_user?(@user) || current_user.admin?
        end

        # Confirms an admin user.
        def admin_user
                redirect_to(root_url) unless current_user.admin?
        end

		def have_permission?
			if !current_user?(@user) && !current_user.admin?
				flash[:warning] = "You have no right"
				redirect_to current_user
				return false
			else
				return true
			end
		end

		def have_team?
			if @relationship == nil
				flash[:warning] = "You still have no team"
				redirect_to current_user
				return false
			else
				return true
			end
		end
		
		def have_project?
			if @assignment == nil
				flash[:warning] = "Project has not been assigned"
				redirect_to current_user
				return false
			else
				return true
			end
		end

		def upload_file(f)
			File.open(Rails.root.join('public', 'uploads', @team.id.to_s, f.original_filename.to_s), 'wb') do |file|
				file.write(f.read)
			end
			flash[:success] = f.original_filename.to_s + " uploaded"
		end
end
