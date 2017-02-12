class RelationshipsController < ApplicationController
    
    before_action :authenticate_user!  #ログインしていない場合はログイン画面に飛ばす

    def create
        followed_user = User.find(params[:user_id])
        if current_user.following? (followed_user)
            current_user.unfollow!(followed_user)
        else
            current_user.follow!(followed_user)
        end
        redirect_to :back
    end

end
