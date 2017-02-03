class CreateUserConfigs < ActiveRecord::Migration
  def change
    create_table :user_configs do |t|
      t.integer :user_id, null: false
      t.boolean :show_reply, null: false, default: true
      t.boolean :restrict_unfollowed, null: false, default: true

      t.timestamps null: false
    end
  end
end
