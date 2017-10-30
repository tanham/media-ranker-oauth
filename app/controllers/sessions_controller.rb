class SessionsController < ApplicationController
  skip_before_action :require_login
  
  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      user = User.find_by(uid: auth_hash[:uid], provider: 'github')
      if user.nil?
        user = User.from_auth_hash(params[:provider], auth_hash)
        user.save
        # flash[:status] = :success
        # flash[:result_text] = "Successfully created new user #{@user.username} with ID #{@user.id}"
        # redirect_to root_path
      else
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as existing user #{user.name}"
        redirect_to root_path
      end

      session[:user_id] = user.id
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not log in"
      flash.now[:messages] = user.errors.messages
      redirect_to root_path
    end
  end


  def index
    @user = User.find_by(session[:user_id])
  end

  def login_form
  end

  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end
  #
  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end


end
