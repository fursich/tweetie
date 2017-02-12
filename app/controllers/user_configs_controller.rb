class UserConfigsController < ApplicationController

    before_action :authenticate_user!  #ログインしていない場合はログイン画面に飛ばす

    def create
        @user_conf = UserConfig.find_or_initialize_by(user_id: current_user.id)
        @user_conf.attributes = user_conf_params
        
        @user_conf.save!
        render nothing: true
    end
    
    private
    def user_conf_params
        params.require(:user_config).permit(:show_replies, :show_followers_only)
    end
end
