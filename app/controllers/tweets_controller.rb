class TweetsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_tweet, only: [:show, :edit, :update, :destroy]
  before_action :init_srch_query, only: [:index, :show, :edit]
  
  def index
    @tweet = Tweet.new
    @tweets = @q.result.page(params[:page]).per(10).order('created_at DESC')
  end
  
  def edit
  end
  def show
  end

  def update
    @tweet.user_id = current_user.id
    @tweet.attributes = tweet_params
    if @tweet.save
      flash[:notice] = I18n.t('tweet.updated')
      redirect_to action: :index
    else
      flash.now[:alert] = @tweet.errors.full_messages
      render :edit
    end
  end

  def create
    @tweet = Tweet.new
    @tweet.user_id = current_user.id
    @tweet.attributes = tweet_params
    if @tweet.save
      redirect_to action: :index
    else
      flash.now[:alert] = @tweet.errors.full_messages
      @q = Tweet.search(params[:q])
      @tweets = @q.result.page(params[:page]).per(10).order('created_at DESC')
      render :index
    end
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
  def init_srch_query
    @q = Tweet.search(params[:q])
  end

end
