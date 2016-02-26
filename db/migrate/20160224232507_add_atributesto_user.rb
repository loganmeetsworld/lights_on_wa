class AddAtributestoUser < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    remove_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :image_url, :string
    add_column :users, :provider, :string
    remove_column :users, :email, :string
  end
end
