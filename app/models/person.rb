# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  email       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  teams_count :integer          default(0)
#  paired      :boolean          default(FALSE)
#

class Person < ActiveRecord::Base

  has_many :memberships
  has_many :teams, through: :memberships

  has_many :partnerships, foreign_key: "person_id"
  has_many :partners, through: :partnerships
  has_many :reverse_partnerships, foreign_key: "partner_id", 
                                  class_name:  "Partnership"
  has_many :reverse_partners, through: :reverse_partnerships, source: :person

  before_save { self.email.downcase! }
  before_save :update_team_counts_and_potential_partners_count

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  def update_team_counts_and_potential_partners_count
    self.teams_count = self.teams.length
    self.potential_partners_count = self.potential_partners.length
  end

  def all_partners
    self.partners + self.reverse_partners
  end

  def potential_partners
    my_teams = self.teams
    my_potential_partners = []

    self.class.all.each do |p|
      unless (p.id == self.id) || (p.paired == true) 
        overlap = my_teams & p.teams
        if overlap.length > 0
          my_potential_partners << p
        end
      end
    end

    my_potential_partners
  end

end
