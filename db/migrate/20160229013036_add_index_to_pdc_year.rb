class AddIndexToPdcYear < ActiveRecord::Migration
  def change
    add_index :candidates, :pdc_id_year, :name => 'candidate_id_index'
  end
end
