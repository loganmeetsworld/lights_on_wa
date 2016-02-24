class AddNewAttributesToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :cont_type, :string
    add_column :contributions, :description, :string
  end
end
