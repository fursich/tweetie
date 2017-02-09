class ChangeColumnDefaultToUserConfigs < ActiveRecord::Migration
  def change
    change_column_default :user_configs, :show_followers_only, false
  end
end
