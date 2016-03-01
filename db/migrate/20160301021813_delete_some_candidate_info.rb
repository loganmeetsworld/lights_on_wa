class DeleteSomeCandidateInfo < ActiveRecord::Migration
  def change
    remove_column :candidates, :email, :string
    remove_column :candidates, :phone, :string
    remove_column :candidates, :address, :string
  end
end
