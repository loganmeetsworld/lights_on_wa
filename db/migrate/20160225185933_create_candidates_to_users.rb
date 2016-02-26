class CreateCandidatesToUsers < ActiveRecord::Migration
  def change
    create_table :candidates_to_users do |t|
      t.integer :candidate_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
