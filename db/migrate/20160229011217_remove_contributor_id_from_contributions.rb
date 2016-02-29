class RemoveContributorIdFromContributions < ActiveRecord::Migration
  def change
    remove_column :contributions, :contributor_id, :integer
    add_column :candidates, :pdc_id_year, :string
    add_column :candidates, :office_type, :string
  end
end
