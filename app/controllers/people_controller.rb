class PeopleController < ApplicationController
  before_filter :signed_in_user

  def index
    @people = Person.all.sort_by(&:name)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person].permit(:name, :email))

    if @person.save
      flash[:success] = "Person created!"
      redirect_to people_url
    else
      render 'new'
    end
  end

end
