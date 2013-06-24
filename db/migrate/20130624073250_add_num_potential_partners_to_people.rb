class AddNumPotentialPartnersToPeople < ActiveRecord::Migration
  def change
    add_column :people, :potential_partners_count, :integer, default: 0
  end
end
