class ServicesController < ApplicationController
  # before_action :authenticate_provider!, except: :index
  # before_action :search_service, only: [:index, :search]

  def index
    @p = Service.ransack(params[:q])
    @services = @p.result.order(created_at: :desc).limit(5)
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

  def search
    @p = Service.ransack(params[:q])
    @services = @p.result

    # @p = Service.search(search_params)
    # @services = @p.result
    # departure_id = params[:q][:departure_id_eq]
    # @departure = Departure.find_by(id: departure_id)  
  end

  def show
    @service = Service.find(params[:id])
    @p = Service.ransack(params[:q])
    @services = @p.result
  end

  private
  
  def service_params
    params.require(:service).permit(:departure_id,:destination_id,:service_type_id, :price, :lead_time, :option_id, :description).merge(provider_id: current_provider.id)
  end

  # def search_service
  # end

  # def search_params
  #   params.require(:q).permit!
  # end

end
