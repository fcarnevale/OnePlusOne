class PeopleController < ApplicationController
  before_filter :signed_in_user

  def index
    @people = Person.all.sort_by(&:name)
  end

end
