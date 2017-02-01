
# tweetie

Twitterをイメージした会話用アプリケーションです｡
bootstrap3によるレスポンシブ対応｡
ログイン機能､画像アップロード､プロフィール編集､検索､ページネーション機能など基本的な機能を備えたcrudアプリケーションです｡

(last update: 2017/2/1 ajaxによる投稿機能､jQueryによる返信画面の畳み込み機能を追加)

### ○ 環境

ruby 2.4.0p0
Rails 4.2.7.1
Cloud 9
MacOS + Chrome, iOS (iPhone 6s) + safariで動作確認

(デプロイ環境)  
Heroku + fog + AWS S3

### ○ 使い方

https://tweetie-app.herokuapp.com/

下記のゲストアカウントででログイン可能｡  

ユーザー名: guest@guest.net
パスワード: guest1

※右上の｢新規登録｣ボタンからユーザー登録もできます｡

ユーザーアカウントが管理者によりロックされた場合､新たなログインができなくなります｡
(例:ロックされたユーザー)

+ ユーザー名: tora@tora.net
+ パスワード: torasan

なお､ユーザーのロック状態を操作できるのは管理者のみです｡
ログイン失敗回数によるロックはかけていません｡

###adminモード

管理者として入ると､以下のことが可能になります｡

1) 全ユーザーのログインIP､ログイン回数などの確認
2) ユーザーのロック状態／ロック解除の切り替え
3) 任意のツイートを削除

+ ユーザー名: admin@admin
+ パスワード: administrator

管理者は､管理者自身の設定を変えられません｡(アカウント名､パスワード､画像､ロック状態などの変更は不可)
ユーザー画面には､右上に｢設定変更｣というリンクがありますが､管理者画面では｢ユーザー管理｣というリンクに変わります｡

### ○ 画面

下記の画面があり､ツイート上や､navbar上のリンク､ロゴをクリックすることで遷移します｡
デザイン要素はミニマムにし､ユーザーがなるべく考えることなく直感的に操作できるよう工夫しました｡

+ ツイート一覧画面(ログイン後のトップページ､左上ロゴをクリックすると常に戻れる)
+ ツイート編集･削除画面(自分のツイートのみ) ･･･ ツイートしたテキスト自体がリンクになっている
+ ツイート詳細画面(親ツイート表示をクリックすることで､返信元をたどることも可能)･･･ツイート時間を表すテキストをクリックする
+ ユーザー情報詳細画面･･･ツイート内のユーザー名や､バー右上のログインユーザー名をクリックすると表示される
+ プロフィール情報変更画面(自分のみ)･･･プロフィール､画像､パスワードなど変更する場合
+ ログイン画面､新規登録画面
+ パスワード再設定画面(現在､再設定メールは動作しません)

### ○ プログラム説明

**Controller**

+ tweets_controller - アプリケーションのメインCRUD機能｡検索結果表示用にget/searchを追加｡

+ users_controller - ユーザー表示画面用､ここから検索かけた場合のみ､ユーザー縛りで検索がかかる(結果は同じ画面で表示)

**View**

+ users - ユーザー表示画面用(show.html.erb)

+ /devise - デフォルトビューを一部カスタマイズ

+ /kaminari - デフォルトビューを一部カスタマイズ

+ /layouts/ - viewportを設定するなどした以外は､ほぼデフォルト

+ /tweets/ - 標準的なビューを格納｡searchは検索結果表示画面(indexと表示ロジックが違うため分けた)

+ /partials/ - パーシャルを格納

  * _header.html.erb              ヘッダー部分(navbar) ロゴやリンクなど､オプションsrchpathを指定すると検索窓を表示(出さない場合はfalseにする)
  * _alert.html.erb               警告表示用､noticeは1行表示､alertは1行､複数行のどちらにも対応
  * _new_tweet.html.erb           新規ツイート投稿用のフォームを表示する(既存ツイートを編集する際にも使用できる)
  * _render_one_tweet.html.erb    ツイートを一つ表示する
  * _trace_tweets.html.erb        ツイートを連続的に表示する｡表示対象から､再帰的に返信先をたどることで表示｡
  * _user_profile.html.erb        ユーザープロフィール表示画面をつくる


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
    
**CSS**

+ common - 主に全体に関わるレイアウト(警告表示など)

+ devise - ログイン関係の画面レイアウト

+ tweets - Tweetに関わる画面レイアウト｡このアプリのメインとなるCI

+ users - Userプロフィール表示レイアウト

**locale**

+ devise.ja.yml - 今回､特定の表示をさせるために細かくカスタマイズ(特にUserに含まれる画像に関するメッセージなど)

+ ja.yml - I18nデフォルト

+ tweet.je.yml - 使われていない

### ○ Gem

以下のgemを使用(説明は省略)

+ devise
+ carrierwave
+ ransack
+ kaminari/kaminari-bootstrap
+ fog
+ bootstrap-sass

### 更新履歴


2017/1/25 仕様確認･開発開始
2017/1/28 α版デプロイ
2017/1/31 管理者機能を追加
2017/2/1  ajax投稿･返信機能を追加

