class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash['uid']
      @user = User.find_or_create_from_omniauth(auth_hash)
      if @user
        session[:user_id] = @user.id
        redirect_to user_path(@user), notice: "Welcome #{current_user.username}!"
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
