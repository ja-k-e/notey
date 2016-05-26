class UsersController < ApplicationController
  before_action :authorize, only: [:create, :update]
  before_action :authorize_owner, only: [:update]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all.order('created_at DESC')

    render json: @users
  end

  def show
    render json: @user, include: ['notes']
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by_username(params[:username])

    if @user.update(user_params)
      head :no_content
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
      render_not_found
    end
  end

  def user_params
    params.require(:user).permit(:username, :password, :api_key)
  end

  def authorize_owner
    @current_user.admin || @current_user == @user
  end
end
