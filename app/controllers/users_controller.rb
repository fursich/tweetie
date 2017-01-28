class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @q = Tweet.search(params[:q])
    @tweets = @q.result.where('user_id=?',params[:id]).first_tweets.page(params[:page]).per(10).order('created_at DESC')
    # first_tweetsは､オリジナルのTweet(返信ではないもの)だけを集めるTweetモデルのscope
  end
end
