class TeamsController < ApplicationController
  before_filter :signed_in_user
  before_filter :set_team, only: [:edit, :update, :destroy]

  def index
    @teams = Person.all.sort_by(&:name)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      flash[:success] = "team created!"
      redirect_to teams_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @team.update_attributes(team_params)
    if @team.save
      flash[:success] = "team updated!"
      redirect_to teams_url
    else
      render 'edit'
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url
  end

  private

    def set_team
      @team = Team.find(params[:id])  
    end

    def team_params
      params[:team].permit(:name)
    end

end
