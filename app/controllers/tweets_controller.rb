class TweetsController < ApplicationController

  before_action :authenticate_user!

  def index
    @tweet = Tweet.new
    @tweets = Tweet.order('created_at DESC')
  end

  def create
    @tweet = Tweet.new
    @tweet.user_id = current_user.id
    @tweet.attributes = tweet_params
    if @tweet.save
    end
    redirect_to action: :index
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content, :reply_id)  # 後で拡張する場合に備えてreply_idも通しておく
  end

end
