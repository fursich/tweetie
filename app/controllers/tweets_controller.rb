class TweetsController < ApplicationController

  before_action :authenticate_user!  #ログインしていない場合はログイン画面に飛ばす
  before_action :find_tweet, only: [:show, :edit, :update, :destroy]  #params[:id]で指定されたTweetインスタンスをセットする
  before_action :init_srch_query, only: [:index, :show, :edit]  #検索窓用のサーチクエリをセットする
  
  def index
    @tweet = Tweet.new
    @tweets = @q.result.first_tweets.page(params[:page]).per(10).order('created_at DESC')
    # first_tweetsは､オリジナルのTweet(返信ではないもの)だけを返すTweetモデルのscope
  end
  
  def edit
  end
  def show
    @new_retweet=Tweet.new
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
    params.require(:tweet).permit(:content, :retweet_id)
  end
  def find_tweet
    @tweet = Tweet.find(params[:id])
  end
  def init_srch_query
    @q = Tweet.search(params[:q])
  end

end
