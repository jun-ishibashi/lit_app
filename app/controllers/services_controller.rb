class ServicesController < ApplicationController
  before_action :search_service, only: [:index, :search]
  before_action :authenticate_provider!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :authorize_provider!, only: [:edit, :update, :destroy]

  def index
    @services = @p.result.order(created_at: :desc).limit(10)
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to root_path, notice: 'サービスを登録しました'
    else
      render :new
    end
  end

  def search
    @services = @p.result
    @shipping_date = params[:shipping_date].presence&.then { |d| Date.parse(d.to_s) }
    @arrival_date = params[:arrival_date].presence&.then { |d| Date.parse(d.to_s) }
    @today = Date.current
  end

  def show
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to service_path(@service), notice: 'サービスを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @service.destroy
    redirect_to root_path, notice: 'サービスを削除しました'
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def authorize_provider!
    redirect_to root_path, alert: '権限がありません' unless current_provider == @service.provider
  end

  def service_params
    params.require(:service).permit(:departure_id, :destination_id, :service_type_id, :price, :lead_time, :option_id,
                                    :description).merge(provider_id: current_provider.id)
  end

  def search_service
    params[:q] = params[:q].permit(SearchParams::RANSACK_KEYS) if params[:q].present?
    @p = Service.ransack(params[:q])
  end
end
