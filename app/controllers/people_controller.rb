class PeopleController < ApplicationController
  before_filter :signed_in_user
  before_filter :set_user, only: [:edit, :update, :destroy]

  def index
    @people = Person.all.sort_by(&:name)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      flash[:success] = "person created!"
      redirect_to people_url
    else
      render 'new'
    end
  end

  def destroy
    @person.destroy
    redirect_to people_url
  end

  private

    def set_user
      @person = Person.find(params[:id])  
    end

    def person_params
      params[:person].permit(:name, :email)
    end

end
