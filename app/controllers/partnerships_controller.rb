class PartnershipsController < ApplicationController
  before_filter :signed_in_user

  def index
    @partnerships = Partnership.all.sort_by!(&:created_at)
  end
end
