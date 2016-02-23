class AddAttributesToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :name, :string
    add_column :candidates, :cand_id, :string
    add_column :candidates, :party, :string
    add_column :candidates, :office, :string
    add_column :candidates, :total_raised, :integer
    add_column :candidates, :total_spent, :integer
    add_column :candidates, :debt, :integer
    add_column :candidates, :cash, :integer
    add_column :candidates, :in_kind, :integer
    add_column :candidates, :anon, :integer
    add_column :candidates, :personal, :integer
    add_column :candidates, :misc, :integer
    add_column :candidates, :small, :integer
  end
end
