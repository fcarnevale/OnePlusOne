# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  person_id  :integer
#  team_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Membership < ActiveRecord::Base
  belongs_to :person
  belongs_to :team
end
