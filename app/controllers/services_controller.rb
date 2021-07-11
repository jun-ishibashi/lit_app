class ServicesController < ApplicationController
  before_action :authenticate_provider!, except: :index

  def index
    @services = Service.all.order('created_at DESC')
  end

  def new 
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to root_path
    else
      render :new
    end
  end

  private
  
  def service_params
    params.require(:service).permit(:departure_id,:destination_id,:service_type_id, :price, :lead_time, :option_id, :description).merge(provider_id: current_provider.id)
  end
end
