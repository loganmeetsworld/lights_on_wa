class AddAttributesToContributors < ActiveRecord::Migration
  def change
    add_column :contributions, :contributor, :string
    add_column :contributions, :date, :string
    add_column :contributions, :amount, :integer    
    add_column :contributions, :city, :string
    add_column :contributions, :state, :string
    add_column :contributions, :zip, :string
    add_column :contributions, :employer, :string
    add_column :contributions, :occupation, :string
  end
end
