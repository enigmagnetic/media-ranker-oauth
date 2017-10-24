class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      @user = User.find_by(uid: auth_hash[:uid], provider: params[:provider])
      if @user.nil?
        @user = User.from_auth_hash(params[:provider], auth_hash)
        if @user.save
          session[:user_id] = user.id
          flash[:status] = :success
          flash[:result_text] = "Successfully added new user #{@user.username}"
        else
          flash[:status] = :failure
          flash[:result_text] = "New user not saved"
        end
      else
        session[:user_id] = @user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as resturning user #{@user.username}"
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not authenticate user information"
    end
    redirect_to root_path
  end

  def login_form
  end

  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = @user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{@user.username} with ID #{@user.id}"
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

  def logout
    if session[:user_id]
      session.delete(:user_id)
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out"
    end
    redirect_to root_path
  end
end
