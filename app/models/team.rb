class Team < ActiveRecord::Base

  has_many :memberships
  has_many :people, through: :memberships

  validates :name,  presence: true, length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

end
