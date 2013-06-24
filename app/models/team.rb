# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Team < ActiveRecord::Base

  has_many :memberships
  has_many :people, through: :memberships

  validates :name,  presence: true, length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

  after_save :update_team_counts_and_potential_partners_count

  def update_team_counts_and_potential_partners_count
    self.people.each do |p|
      p.teams_count = p.teams.length
      p.potential_partners_count = p.potential_partners.length
      p.save
    end
  end

end
