class SessionsController < ApplicationController
    before_action :require_logged_out, only: [:new, :create]
    def new
        @user = User.new
        render :new
    end
    
    def create
        @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
        if @user
            @user.reset_session_token!
            session[:session_token] = @user.session_token
            login(@user)
            redirect_to cats_url
        else
            render :new
        end
    end

    def destroy
        current_user.reset_session_token!
        session[:session_token] = nil 
    end

end
