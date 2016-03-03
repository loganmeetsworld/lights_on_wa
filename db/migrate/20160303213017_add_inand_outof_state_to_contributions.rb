class AddInandOutofStateToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :instate, :boolean
  end
end
