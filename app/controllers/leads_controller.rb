class LeadsController < ApplicationController
  def index
    redirect_to root_path
  end

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)

    unless @lead.save
      render :new
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:email, :name)
  end 
end
