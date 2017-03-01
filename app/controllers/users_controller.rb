class UsersController < ApplicationController
  include Common

  before_action :find_user, only: [:alt_lock, :follower_list, :following_list]
  before_action :authenticate_user!  #ログインしていない場合はログイン画面に飛ばす
  before_action :init_emotions
  
  def index
    @users = User.all.includes(:tweets).sort_by_login_date_with(params[:page])

  end
  
  def show
    @user = User.includes(:tweets).find(params[:id])
    @q = Tweet.where(user_id: params[:id]).search(params[:q])
    @tweets = @q.result.sort_by_created_date_with(params[:page])
    # オリジナルのTweetだけでなく､返信もあわせて表示･検索対象にする

  end
  
  def alt_lock
    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    
    redirect_to :back
  end
  
  def follower_list
    @users = @user.followers.sort_by_login_date_with(params[:page])
    render action: :follows
  end

  def following_list
    @users = @user.following.sort_by_login_date_with(params[:page])
    render action: :follows
  end

  private
  def find_user
    @user = User.find(params[:id])
  end
  def init_emotions
    @emotions = Reaction.emotions
    @emotion_array = create_emotion_array
  end
end
