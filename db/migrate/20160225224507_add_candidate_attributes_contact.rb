class AddCandidateAttributesContact < ActiveRecord::Migration
  def change
    add_column :candidates, :address, :string
    add_column :candidates, :city, :string   
    add_column :candidates, :state, :string
    add_column :candidates, :zip, :string    
    add_column :candidates, :email, :string
    add_column :candidates, :phone, :string
  end
end
