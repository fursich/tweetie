# tweetie

<br />
Twitterをイメージした会話用アプリケーションです｡  
<br />
<br />

<div align='center'>
<img src="https://raw.githubusercontent.com/fursich/tweetie/master/public/images/screenshots/tweetie_screenshot.png" width='700px'>
</div>

<br />
<br />

ログイン認証､画像アップロード､フォロー/アンフォロー､検索機能など基本的な機能を備えたユーザーコミュニケーション用のcrudアプリケーションです｡  
Heroku + fog + AWS S3にてデプロイ。レスポンシブ対応｡  

last update:  
2017/2/14 ソーシャルログイン機能を追加（facebook/twitter）  

<br />
<br />

### ○ 使い方  

https://tweetie-app.herokuapp.com/

下記のゲストアカウントでログイン可能｡  
　　
+ ユーザー名: guest@guest.net　　
+ パスワード: guest1　　
  
Twitter/Facebookアカウントでもログインできます。
（ログアウト時に、タイトルバーの「設定変更」から退会処理をすることで、SNSアカウントの情報をDBから削除することが可能）  

<br />

### adminモード  

管理者として入ると､以下のことが可能になります｡  
  
1) 全ユーザーのログインIP､ログイン回数などの確認  
2) ユーザーのロック状態／ロック解除の切り替え  
3) 任意のツイートを削除  
　　
+ ユーザー名: admin@admin
+ パスワード: administrator  

<br />
<hr />
<br />
### 仕様

#### ダッシュボード画面を中心とした画面遷移  
画面上では、ほとんどどの要素もクリック可能になっています。なるべくスムーズで直感的な操作ができるように意図しました。  

#### ユーザー認証画面  
devise/OmniAuthを利用。新規登録・サインイン・登録情報の編集・削除（退会）ができます。  

<br />
<br />

<div align='center'>
<img src="https://raw.githubusercontent.com/fursich/tweetie/master/public/images/screenshots/tweetie_UI_2_overall.png" width='800px'> </div>
<br />
<br />

<br />
<br />

<div align='center'>
<img src="https://raw.githubusercontent.com/fursich/tweetie/master/public/images/screenshots/tweetie_UI_1_auth.png" width='600px'>
</div>

<br />
<br />

<hr/>

### ○ プログラム説明

**Controller**

+ tweets_controller - アプリケーションのメインCRUD機能｡検索結果表示用にget/searchを追加｡

+ users_controller - ユーザー表示画面用､ここから検索かけた場合のみ､ユーザー縛りで検索がかかる(結果は同じ画面で表示)

+ user_configs_controller - 画面の表示設定(フォロー表示/返信表示モード)切り替え処理(表示はajax処理のため､バックグラウンドでconfigデータ更新のみ行う)

+ reactions_controller - ツイートに対するリアクションがあった時の､ajax表示･データ更新

+ relationships_controller - ユーザー間のフォロー･非フォロー切り替え操作

**View**

+ users - ユーザー表示画面用(show.html.erb)

+ /devise - デフォルトビューを一部カスタマイズ

+ /kaminari - デフォルトビューを一部カスタマイズ

+ /layouts/ - viewportを設定するなどした以外は､ほぼデフォルト

+ /tweets/ - 標準的なビューを格納｡searchは検索結果表示画面(indexと表示ロジックが違うため分けた)

+ /partials/ - パーシャルを格納

  * _header.html.erb              ヘッダー部分(navbar) ロゴやリンクなど､オプションsrchpathを指定すると検索窓を表示(出さない場合はfalseにする)
  * _alert.html.erb               警告表示用､noticeは1行表示､alertは1行､複数行のどちらにも対応
  * _new_tweet.html.erb           新規ツイート投稿用のフォームを表示する(既存ツイートを編集する際にも使用できる)
  * _render_one_tweet.html.erb    ツイートを一つ描画する
  * _trace_tweets.html.erb        ツイートを連続的に表示する｡表示対象から､再帰的に返信先をたどることで表示｡
  * _ajax_new_tweet.html.erb      新規ツイートポスト時のajax更新用パーシャル
  * _user_profile.html.erb        ユーザープロフィール表示画面をつくる
  * _reaction_counter.html.erb    ツイートに対するリアクションを表示するカウンター
  * _reaction_buttons.html.erb    ツイートにリアクションをつけるためのボタン
  * _config_options.html.erb      index画面における表示設定切り替え用タブ･チェックボックス描画  
  * _user_account_info.html.erb   管理者用のユーザー一覧画面(ログイン日時､ロック状況などの表示)    

**Model**

+ tweet.rb - ツイート内容を格納

   * parent_tweet: 返信元の親ツイート､retweet: 返信された子ツイート
   * validation､メソッドなどの詳細はtweet.rbに記載

+ user.rb - ユーザー情報

    * ユーザー名(アカウント名)であるnameは､使える文字に制限をかけている上に､unique設定とした
    * 画像に関しては､ファイル名(拡張子)と､サイズでのバリデーションがかかっている
    * ファイルサイズでのバリデーションに関しては､下記のgistから流用｡(アップロード後に判定する仕様)
    https://gist.github.com/chrisbloom7/1009861
    * アップロード後にバリデーションに引っかかり､キャッシュに残った大きなファイルのせいで
      登録に進めなくなることを防ぐために､画像を消去するオプションを追加
    * 上と関連して､画像をもし登録できなくても､デフォルト画像を表示する仕様に変更した

+ user_config.rb - ユーザー画面設定情報

    * Userと一対一で対応し､ユーザーごとの設定を保存する
    * show_reply: 返信を表示するかどうかをbooleanで格納
    * restrict_unfollowed: (今後実装予定､現在カラムのみ) trueの場合､フォローしているユーザーだけを見せる､falseなら全ユーザー表示

+ reaction.rb

    * UserとTweetに所属し､あるツイートに対する､特定のユーザーのリアクションを保存する
    * emotion: enumを使って､複数種類のリアクションから1つを選ぶ

+ relationship.rb

    * フォロー/被フォローという､ユーザー間の非対称の多対多関係を表現するモデル

**Helper**

+ reactions_helper.rb

    * class_by_emotion(emotion) 与えられたemotionごとに､該当する絵文字を表すクラス名を戻す｡  
                                (reactionオブジェクトのデータに対して､絵文字を対応させている)

+ tweets_helper.rb
    * my_tweet?(tweet) tweetがcurrent_userのツイートかどうかを判定する

**javascripts**

+ reactions.js

    * リアクションボタンに関わる機能
    * マウスオーバーでリアクションボタンが出てくる動作
    * ボタンを押した時にカウンターが変わる動作など

+ tweets.js

    * メイン画面における主要な機能
    * ツイート投稿をajax処理
    
+ user_configs.js

    * フォロワー以外の表示･非表示切り替え
    * 返信画面の表示･非表示切り替え

**CSS**

+ common - 主に全体に関わるレイアウト(警告表示など)

+ devise - ログイン関係の画面レイアウト

+ tweets - Tweetに関わる画面レイアウト｡このアプリのメインとなるCI

+ users - Userプロフィール表示レイアウト

**locale**

+ devise.ja.yml - 今回､特定の表示をさせるために細かくカスタマイズ(特にUserに含まれる画像に関するメッセージなど)

+ ja.yml - I18nデフォルト

+ tweet.ja.yml - 使われていない

### ○ Gem

以下のgemを使用

+ devise
+ carrierwave
+ ransack
+ kaminari/kaminari-bootstrap
+ fog  
+ omniauth  
+ omniauth-facebook  
+ omniauth-twitter  
+ bootstrap-sass
+ font-awesome-sass
  
### ○ 環境
  
ruby 2.4.0p0  
Rails 4.2.7.1  
Cloud 9  
MacOS + Chrome, iOS (iPhone 6s) + safariで動作確認
  
(デプロイ環境)  
Heroku + fog + AWS S3  
  
### 更新履歴


2017/1/25 仕様確認･開発開始  
2017/1/28 α版デプロイ  
2017/1/31 管理者機能を追加  
2017/2/1  ajax投稿･返信機能追加｡返信画面の畳み込み機能追加  
2017/2/3  ユーザーごとの表示設定を追加｡ajaxで記録し次回ログイン時に反映(現状､返信画面表示･非表示の設定のみ)  
2017/2/4  ツイートに対するリアクションボタン(笑顔や♥などのアイコン)を追加  
2017/2/9  フォロー･アンフォロー機能を追加､UIを一部変更　　
2017/2/12 リアクションボタンをポップアップ（モーダル）化、フォロワー・フォロー中の一覧表示を追加　　
2017/2/14 ソーシャルログイン機能を追加（facebook/twitter）  
