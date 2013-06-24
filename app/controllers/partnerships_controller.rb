class PartnershipsController < ApplicationController
  before_filter :signed_in_user
  before_filter :set_partnership, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @partnerships = Partnership.all.sort_by(&:person_id)
  end

  def new
    @partnership = Partnership.new
  end

  def create
    @partnership = Partnership.new(partnership_params)

    if @partnership.save
      flash[:success] = "partnership created!"
      redirect_to partnerships_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @partnership.update_attributes(partnership_params)
    if @partnership.save
      flash[:success] = "partnership updated!"
      redirect_to partnerships_url
    else
      render 'edit'
    end
  end

  def destroy
    @partnership.destroy
    redirect_to partnerships_url
  end

  private

    def set_partnership
      @partnership = Partnership.find(params[:id])  
    end

    def partnership_params
      params[:partnership].permit(:person_id, :partner_id)
    end

end
