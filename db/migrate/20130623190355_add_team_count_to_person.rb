class AddTeamCountToPerson < ActiveRecord::Migration
  def change
    add_column :people, :teams_count, :integer, default: 0
  end
end
