class UsersController < ApplicationController
  def show
    @user = User.includes(:tweets).find(params[:id])
    @q = @user.tweets.includes(:user).search(params[:q])
    @tweets = @q.result.page(params[:page]).per(10).order('created_at DESC')

    # オリジナルのTweetだけでなく､返信もあわせて表示･検索対象にする

  end
end
