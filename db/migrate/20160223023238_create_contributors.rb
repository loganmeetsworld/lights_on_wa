class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :zip
      t.string :employer
      t.string :occupation

      t.timestamps null: false
    end
  end
end
