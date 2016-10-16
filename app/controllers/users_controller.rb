class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action(:find_user, only: [:show, :edit, :update, :destroy])

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = current_user.users.create(user_params)
    redirect_to_user_if_valid('You successfully created a user')
  end

  def edit
    find_user
    unless current_or_admin
      redirect_to root_path, notice: 'You cannot edit this user!'
    end
  end

  def update
    unless current_or_admin
      @user.update(user_params)
    end
    redirect_to_user_if_valid('You successfully updated a user')
  end

  def destroy
    @user.destroy
    redirect_to(users_path)
  end

  private

  def current_or_admin
    current_user.admin? || current_user == @user
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params[:user].permit(:name,:headline,:profile,:email,:admin)
  end

  def redirect_to_user_if_valid(notice)
    redirect_to(@user, notice: notice) if @user.valid?
  end

  def redirect_to_user(notice)
    redirect_to(@user, notice: notice)
  end

end
