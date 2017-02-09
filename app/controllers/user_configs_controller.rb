class UserConfigsController < ApplicationController

    def create
        @user_conf = UserConfig.find_or_initialize_by(user_id: current_user.id)
        @user_conf.show_replies = params[:show_replies]
        @user_conf.show_followers_only = params[:show_followers_only]
        @user_conf.save!
        render nothing: true
    end
    
    private
    def user_conf_params
        params.require(:user_config).permit(:show_replies, :show_followers_only)
    end
end
