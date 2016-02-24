class AddAttributesToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :pdc_id, :string
    add_column :candidates, :name, :string
    add_column :candidates, :year, :string
    add_column :candidates, :office, :string
    add_column :candidates, :party, :string
    add_column :candidates, :raised, :integer
    add_column :candidates, :spent, :integer
    add_column :candidates, :debt, :integer
    add_column :candidates, :ind_spend, :integer
    add_column :candidates, :ind_opp, :integer
    add_column :candidates, :dist, :string
    add_column :candidates, :pos, :string
    add_column :candidates, :court, :string
    add_column :candidates, :locality, :string
  end
end
