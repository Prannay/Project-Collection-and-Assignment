require 'securerandom'
class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def contact
  end

	def login
	end

  def new
		email = session[:cas_user].to_s+"@tamu.edu"
		user = User.find_by(email: email)
		if user
			log_in user
			remember(user)
			redirect_back_or user
		else
			passwd = SecureRandom.hex
			user = User.new(:name => "Please Update", :email => email, :password_digest => passwd)	
		  if user.save
		     log_in user
		     flash[:success] = "Welcome to the ProjectApp"
		     redirect_to user
		  else
		     render 'new'
		  end

		end
  end
  
  def create
    user = User.find_by(email: params[:static_pages][:email].downcase)
    if user && user.authenticate(params[:static_pages][:password])
      log_in user
      params[:static_pages][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
      # Log the user in and redirect to the user's show page.
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    #redirect_to root_url
  end

end
