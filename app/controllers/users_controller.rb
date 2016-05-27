class UsersController < ApplicationController
  before_action :authorize, only: [:create, :keys, :key, :destroy]
  before_action :authorize_admin, only: [:create, :keys, :key, :destroy]
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.all.order('created_at DESC').limit(20)

    render json: @users
  end

  def keys
    @keys = UserKeys.new.keys

    render json: @keys
  end

  def key
    @key = UserKeys.new.key(params[:username])

    render json: @key
  end

  def show
    render json: @user, include: ['notes']
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    head :no_content
  end

  private

  def set_user
    begin
      @user = User.find_by_username(params[:username])
    rescue
      render_not_found('User', params[:username])
    end
  end

  def user_params
    params.require(:user).permit(:username, :api_key)
  end

  def authorize_owner
    @current_user.admin || @current_user == @user
  end
end
