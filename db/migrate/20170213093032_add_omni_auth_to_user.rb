class AddOmniAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :provider_token, :string
    add_column :users, :provider_uid, :string
  end
end
