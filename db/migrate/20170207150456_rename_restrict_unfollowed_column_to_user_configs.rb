class RenameRestrictUnfollowedColumnToUserConfigs < ActiveRecord::Migration
  def change
    rename_column :user_configs, :restrict_unfollowed, :show_followers_only
    rename_column :user_configs, :show_reply, :show_replies
  end
end
