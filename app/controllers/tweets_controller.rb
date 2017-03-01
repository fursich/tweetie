class TweetsController < ApplicationController
  include Common

  before_action :authenticate_user!  #ログインしていない場合はログイン画面に飛ばす
  before_action :find_tweet, only: [:show, :edit, :update, :destroy]  #params[:id]で指定されたTweetインスタンスをセットする
  before_action :init_emotions
  before_action :init_srch_query, only: [:index, :show, :edit, :search]  #検索窓用のサーチクエリをセットする
  
  def index
    @user_config = UserConfig.find_or_initialize_by(user_id: current_user.id)

    @tweets = Tweet.all.includes(:retweets, :user, :reactions).sort_by_created_date_with(params[:page])
    @first_tweets = @tweets.first_tweets
    # first_tweetsは､オリジナルのTweet(返信ではないもの)だけを返すTweetモデルのscope
    # 検索結果はsearchコントローラーで別に処理｡(返信も検索対象に含めて表示させたいので､処理を分けている)

    @tweet = Tweet.new
  end
  
  def search
    @tweets = @q.result.sort_by_created_date_with(params[:page])

    # サーチ結果から､さらにネストしたサーチはしない(indexからサーチかけた場合と同じ結果になる)
    # (重層サーチする場合は､init_srch_queryをカスタマイズ｡説明を入れないとユーザーが混乱させる可能性あり)
  end
  
  def edit
  end
  def show
    @new_retweet=Tweet.new
  end

  def update      #updateに関してはindex画面へ戻るため､ajaxなしとする
    @tweet.user_id = current_user.id
    @tweet.attributes = tweet_params
    if @tweet.save
      flash[:notice] = I18n.t('tweet.updated')
      redirect_to action: :index
    else
      flash.now[:alert] = @tweet.errors.full_messages
      init_srch_query
      render :edit
    end
  end

  def create
    @tweet = Tweet.new
    @tweet.user_id = current_user.id
    @tweet.attributes = tweet_params
    if @tweet.save
      respond_to do |format|
        format.html do
          redirect_to action: :index
        end
        format.json do
          new_html = render_to_string partial: 'partials/ajax_new_tweet', formats: :html, locals: {t: @tweet}
          render json: {result: 'success', html: new_html}
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = @tweet.errors.full_messages
          init_srch_query
          @user_config = UserConfig.find_or_initialize_by(user_id: current_user.id)
          @tweets = Tweet.all.includes(:retweets, :user, :reactions).sort_by_created_date_with(params[:page])
          @first_tweets = @tweets.first_tweets

          redirect_to :back
        end
        format.json do
          render json: {result: 'failure', error_message: @tweet.errors.full_messages}
        end
      end
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
  def init_emotions
    @emotions = Reaction.emotions
    @emotion_array = create_emotion_array
  end


end
