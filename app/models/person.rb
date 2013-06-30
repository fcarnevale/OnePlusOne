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
    partners_ids = self.partners.map { |p| p.id }
    reverse_partners_ids = self.reverse_partners.map { |p| p.id }
    all_partners_ids = partners_ids + reverse_partners_ids
    all_partners_ids.uniq!
    return all_partners_ids
  end

  def potential_partners
    potential_partners_ids = []

    self.class.all.each do |p|
      unless (p.id == self.id) 
        overlap = self.teams & p.teams
        if overlap.length > 0
          potential_partners_ids << p.id
        end
      end
    end

    return potential_partners_ids
  end

  def least_recent_partner
    return self.least_recent_partners.first
  end

  def least_recent_partners
    least_recent_partners = self.least_recent_partnerships.collect do |p|
      if p.partner_id == self.id
        p.person_id
      elsif p.person_id == self.id
        p.partner_id
      end
    end
    return least_recent_partners
  end

  def least_recent_partnerships
    least_recent_partnerships = []
    self.potential_partners.each do |pp_id|
      partnership = Partnership.where("(partner_id = ? AND person_id = ?) OR (person_id = ? AND partner_id = ?)", self.id, pp_id, self.id, pp_id).recent.limit(1).first
      least_recent_partnerships << partnership if partnership
    end

    least_recent_partnerships.sort_by!(&:created_at)
    return least_recent_partnerships
  end

  def never_partnered_with
    potential_partners_ids = self.potential_partners
    if self.all_partners
      all_partners_ids = self.all_partners
      return (potential_partners_ids - all_partners_ids)
    else
      return potential_partners_ids
    end
  end

  def most_recent_partner
    most_recent_partnership = Partnership.where("(partner_id = ? OR person_id = ?)", self.id, self.id).recent.limit(1).first
    return most_recent_partnership.partner_id unless most_recent_partnership.partner_id == self.id
    return most_recent_partnership.person_id unless most_recent_partnership.person_id == self.id
  end

  def self.last_on_never_partnered_list?(id)
    # No longer implemented anywhere, but keep in the event that more people are added to the app
    self.all.each do |person|
      return true if person.never_partnered_with.count == 1 && person.never_partnered_with.include?(id)      
    end
    
    return false
  end

  def current_partner
    current_partnership = Partnership.current.recent.where("(partner_id = ? OR person_id = ?)", self.id, self.id).limit(1).first
    if current_partnership
      return self.class.find(current_partnership.partner_id) unless current_partnership.partner_id == self.id
      return self.class.find(current_partnership.person_id) unless current_partnership.person_id == self.id
    end
    return ""
  end

end
