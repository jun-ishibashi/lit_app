class ServicesController < ApplicationController
  before_action :authenticate_any!, only: [:show, :search]
  # before_action :authenticate_user!, except: [:index, :show]
  # before_action :authenticate_provider!, only: [:index, :show]
  before_action :search_service, only: [:index, :search, :show]

  def index
    @services = @p.result.order(created_at: :desc).limit(10)
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
    @services = @p.result
    if params[:shipping_date]
      @shipping_date = params[:shipping_date]
      @shipping_date = @shipping_date.to_date
    end
    @arrival_date = params[:arrival_date]
    @arrival_date = @arrival_date.to_date

    @today = Date.today
  end

  def show
    @service = Service.find(params[:id])
    @services = @p.result
  end

  def destroy
    service = Service.find(params[:id])
    service.destroy
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
    service = Service.find(params[:id])
    service.update(service_params)
  end

  private

  def service_params
    params.require(:service).permit(:departure_id, :destination_id, :service_type_id, :price, :lead_time, :option_id,
                                    :description).merge(provider_id: current_provider.id)
  end

  def search_service
    @p = Service.ransack(params[:q])
  end

  def authenticate_any!
    if provider_signed_in?
      true
    else
      authenticate_user!
    end
  end
end
