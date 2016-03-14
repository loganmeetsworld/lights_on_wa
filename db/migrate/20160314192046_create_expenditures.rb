class CreateExpenditures < ActiveRecord::Migration
  def change
    create_table :expenditures do |t|
      t.string :date
      t.integer :amount
      t.string :candidate_id
      t.string :description
      t.string :city
      t.string :state
      t.string :zip
      t.boolean :instate

      t.timestamps null: false
    end
  end
end
