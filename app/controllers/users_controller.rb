class UsersController < ApplicationController
  def show
    @q = Tweet.search(params[:q])
    @tweets = @q.result.where('user_id=?',params[:id]).page(params[:page]).per(10).order('created_at DESC')
  end
end
