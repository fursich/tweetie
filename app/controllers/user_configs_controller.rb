class UserConfigsController < ApplicationController

    def create
        user_conf = UserConfig.find_or_initialize_by(user_id: current_user.id)
        user_conf.show_reply = (params[:show_reply] == 'true' ? true : false)
        user_conf.save!
        render nothing: true
    end
    
    private
    def user_conf_param
        params.require(:user_config).permit(:show_reply)
    end
end
