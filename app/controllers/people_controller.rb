class PeopleController < ApplicationController
  before_filter :signed_in_user
  before_filter :set_person, only: [:show, :edit, :update, :destroy]

  def show
  end

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

  def edit
  end

  def update
    @person.update_attributes(person_params)
    if @person.save
      flash[:success] = "person updated!"
      redirect_to people_url
    else
      render 'edit'
    end
  end

  def destroy
    @person.destroy
    redirect_to people_url
  end

  private

    def set_person
      @person = Person.find(params[:id])  
    end

    def person_params
      params[:person].permit(:name, :email)
    end

end
