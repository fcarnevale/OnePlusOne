class PagesController < ApplicationController
  before_filter :signed_in_user, only: [:dashboard]

  def home
  end

  def dashboard
  end

end