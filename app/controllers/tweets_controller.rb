class TweetsController < ApplicationController

  before_action :authenticate_user!  #ログインしていない場合はログイン画面に飛ばす
  before_action :find_tweet, only: [:show, :edit, :update, :destroy]  #params[:id]で指定されたTweetインスタンスをセットする
  before_action :init_srch_query, only: [:index, :show, :edit, :search]  #検索窓用のサーチクエリをセットする
  
  def index
    @tweet = Tweet.new
    @tweets = Tweet.all.includes(:retweets, :user).first_tweets.page(params[:page]).per(10).order('created_at DESC')

    # first_tweetsは､オリジナルのTweet(返信ではないもの)だけを返すTweetモデルのscope
    # 検索結果はsearchコントローラーで別に処理｡(返信も検索対象に含めて表示させたいので､処理を分けている)
  end
  
  def search
    @tweets = @q.result.page(params[:page]).per(10).order('created_at DESC')

    # サーチ結果から､さらにネストしたサーチはしない(indexからサーチかけた場合と同じ結果になる)
    # (重層サーチする場合は､init_srch_queryをカスタマイズ｡説明を入れないとユーザーが混乱させる可能性あり)
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
      respond_to do |format|
        format.html {redirect_to action: :index}
        format.json {
          new_html = render_to_string partial: 'partials/render_one_tweet', formats: :html, locals: {t: @tweet}
          render json: {status: 'success', html: new_html}
          }
      end
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
