class AddPairedToPeople < ActiveRecord::Migration
  def change
    add_column :people, :paired, :boolean, default: false
  end
end
