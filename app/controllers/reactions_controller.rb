class ReactionsController < ApplicationController
  def create
    @target_tweet = Tweet.find(params[:tweet_id])
    @reaction = @target_tweet.reactions.find_or_initialize_by(user_id: current_user.id)
    @reaction.emotion = params[:emotion]
  
    @has_emotion = @reaction.changed?

    @result = if @has_emotion
                @reaction.save
              else
                @reaction.destroy
              end
    respond_to do |format|
      format.html {redirect_to root_path}
      format.json {render json: render_json}
    end
  end
  
  private
  
  def render_json
    if @result
      {
      result: 'success',
      tweet_id: @target_tweet.id,
      has_emotion: @has_emotion,
      html: emotion_icons_partial
      }
    else
      {
      result: 'failure'
      }
    end

  end

  def emotion_icons_partial
    return nil unless @target_tweet.has_any_reactions?
    render_to_string partial: 'partials/reaction_buttons', formats: :html, locals: {t: @target_tweet}
  end
  
end
