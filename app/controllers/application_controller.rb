class ApplicationController < ActionController::API
  before_action :authorize_admin, only: [:destroy]

  def current_user
    return false unless params[:auth]
    @current_user ||= User.find_by_username(params[:auth][:username]) if params[:auth][:username]
    return false unless @current_user && @current_user.authenticate(params[:auth][:password])
    true
  end
  helper_method :current_user

  def authorize
    render_rejection unless current_user && valid_secret
  end

  def authorize_admin
    render_rejection unless @current_user.admin
  end

  private

  def auth_params
    params.require(:auth).permit(:username, :password, :api_key)
  end

  def valid_secret
    return true if @current_user.admin
    return false unless params[:auth]
    params[:auth][:api_key] == @current_user.api_key
  end

  def render_rejection
    render json: { error: 'you aint auth\'d, yo.' }, status: :unauthorized and return
  end
end