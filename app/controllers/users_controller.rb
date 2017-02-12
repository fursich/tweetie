class UsersController < ApplicationController

  before_action :find_user, only: [:update, :follower_list, :following_list]
  before_action :authenticate_user!  #ログインしていない場合はログイン画面に飛ばす

  def index
    @users = User.all.includes(:tweets).page(params[:page]).per(10).order('current_sign_in_at DESC')

  end
  
  def show
    @user = User.includes(:tweets).find(params[:id])
    @q = @user.tweets.includes(:user).search(params[:q])
    @tweets = @q.result.page(params[:page]).per(10).order('created_at DESC')
    # オリジナルのTweetだけでなく､返信もあわせて表示･検索対象にする

  end
  
  def update
    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    
    redirect_to action: :index
  end
  
  def follower_list
    @users = @user.followers.page(params[:page]).per(10).order('current_sign_in_at DESC')
  end

  def following_list
    @users = @user.following.page(params[:page]).per(10).order('current_sign_in_at DESC')
  end

  private
  def find_user
    @user = User.find(params[:id])
  end
end
