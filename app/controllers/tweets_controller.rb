class TweetsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_tweet, only: [:show, :edit, :update, :destroy]

  def index
    @tweet = Tweet.new
    @tweets = Tweet.order('created_at DESC')
  end
  
  def show
  end

  def edit
  end
  def update
    @tweet.user_id = current_user.id
    @tweet.attributes = tweet_params
    if @tweet.save
      flash[:notice] = I18n.t('tweet.updated')
    else
      flash[:alert] = I18n.t('tweet.save_failed')
    end
    redirect_to action: :index
  end

  def create
    @tweet = Tweet.new
    @tweet.user_id = current_user.id
    @tweet.attributes = tweet_params
    unless @tweet.save
      flash[:alert] = I18n.t('tweet.save_failed')
    end
    redirect_to action: :index
  end

  def destroy
    @tweet.destroy!
    flash[:notice] = I18n.t('tweet.deleted')
    redirect_to action: :index
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content, :reply_id)  # 後で拡張する場合に備えてreply_idも通しておく
  end
  def find_tweet
    @tweet = Tweet.find(params[:id])
  end

end
