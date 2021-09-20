class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?, :login_user!, :logout!, :require_logged_out

    def current_user
        return nil unless session[:session_token]
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in?
        !!current_user
    end

    def login_user!(user)
        session[:session_token] = user.reset_session_token!
    end

    def logout!
        current_user.reset_session_token! if logged_in?
        session[:session_token] = nil
        @current_user = nil
    end

    def require_logged_out
        redirect_to cats_url if logged_in?
    end


end
