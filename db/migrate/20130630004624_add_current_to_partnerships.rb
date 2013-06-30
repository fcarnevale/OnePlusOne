class AddCurrentToPartnerships < ActiveRecord::Migration
  def change
    add_column :partnerships, :current, :boolean, default: false
  end
end
