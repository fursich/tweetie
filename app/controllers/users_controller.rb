class UsersController < ApplicationController

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
    @user = User.find(params[:id])
    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    
    redirect_to action: :index
  end
end
