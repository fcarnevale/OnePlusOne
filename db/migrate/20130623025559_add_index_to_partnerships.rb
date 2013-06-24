class AddIndexToPartnerships < ActiveRecord::Migration
  def change
    add_index :partnerships, :person_id
    add_index :partnerships, :partner_id
    add_index :partnerships, [:person_id, :partner_id]
  end
end
