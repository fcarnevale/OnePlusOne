class AddIndexToMemberships < ActiveRecord::Migration
  def change
    add_index :memberships, :person_id
    add_index :memberships, :team_id
    add_index :memberships, [:person_id, :team_id], unique: true
  end
end
