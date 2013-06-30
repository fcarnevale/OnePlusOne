# == Schema Information
#
# Table name: partnerships
#
#  id         :integer          not null, primary key
#  person_id  :integer
#  partner_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Partnership < ActiveRecord::Base
  belongs_to :person,  class_name: "Person"
  belongs_to :partner, class_name: "Person"

  scope :recent, :order => 'partnerships.created_at DESC'
  scope :current, where(current: "true") 
end
