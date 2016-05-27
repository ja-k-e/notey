class ApplicationController < ActionController::API
  def current_user
    return false unless params[:auth]
    @current_user ||= User.find_by_username(params[:auth][:username]) if params[:auth][:username]
  end
  helper_method :current_user

  def authorize
    render_rejection unless current_user && valid_secret
  end

  def authorize_admin
    render_rejection unless current_user && @current_user.admin
  end

  def authorize_slack
    render_rejection unless valid_slack_token
  end

  private

  def auth_params
    params.require(:auth).permit(:username, :api_key)
  end

  def valid_secret
    return false unless params[:auth]
    params[:auth][:api_key] == @current_user.api_key
  end

  def valid_slack_token
    Rails.application.secrets.slack_tokens.include? slack_note_params[:token]
  end

  def render_rejection
    render json: { error: 'you aint auth\'d, yo.' }, status: :unauthorized and return
  end

  def render_not_found(model, param)
    render json: { error: "#{model} '#{param}' doesn't exist, yo." }, status: :not_found and return
  end
end
