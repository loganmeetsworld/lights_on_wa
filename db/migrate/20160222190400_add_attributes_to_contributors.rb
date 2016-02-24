class AddAttributesToContributors < ActiveRecord::Migration
  def change
    add_column :contributions, :date, :string
    add_column :contributions, :amount, :integer
    add_column :contributions, :candidate_id, :string  
    add_column :contributions, :contributor_id, :string  
  end
end
