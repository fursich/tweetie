class Devise::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth = request.env["omniauth.auth"]
    @user = User.where(provider: auth.provider, provider_uid: auth.uid).first
    unless @user
      # ユーザが無い場合は作成
      @user = User.create(
          name:     auth.extra.raw_info.name,
          email:    dummy_email(auth),
          provider: auth.provider,
          provider_token:    auth.credentials.token,
          provider_uid: auth.uid,
          password: Devise.friendly_token[0,20],
          encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join,
          profile: '(loggedin via facebook)'
      )
    end

  
    if @user.persisted?
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    auth = request.env["omniauth.auth"]
    @user = User.where(provider: auth.provider, provider_uid: auth.uid).first
    unless @user
      # ユーザが無い場合は作成
      @user = User.create(
          name:     login_name_via_sns(auth.info.nickname,auth.provider),
          email:    dummy_email(auth),
          provider: auth.provider,
          provider_token:    auth.credentials.token,
          provider_uid: auth.uid,
          password: Devise.friendly_token[0,20],
          encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join,
          profile: '(loggedin via twitter)'
      )
    end

    if @user.persisted?
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  private
  
  def dummy_email(auth)
    "#{auth.provider}-#{auth.uid}@registered-via-sns.temp"
  end
  def login_name_via_sns(name, provider)
    "_#{name}_#{provider}".slice(0,20)
  end

end
