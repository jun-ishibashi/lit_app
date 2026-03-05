# frozen_string_literal: true

class QuoteRequestsController < ApplicationController
  before_action :require_login_for_quote_requests, only: %i[index show]
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_service_for_quote_request, only: %i[new create]
  before_action :set_quote_request, only: [:show]
  before_action :authorize_quote_request!, only: [:show]

  def index
    @quote_requests, @as_provider = load_quote_requests_for_current_role
  end

  def show
  end

  def new
    @quote_request = current_user.quote_requests.build(service: @service)
  end

  def create
    @quote_request = current_user.quote_requests.build(quote_request_params.merge(service: @service))
    if @quote_request.save
      redirect_to quote_request_path(@quote_request), notice: "見積もり依頼を送信しました。業者から連絡があるまでお待ちください。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_service_for_quote_request
    service_id = params[:service_id] || params.dig(:quote_request, :service_id)
    @service = Service.find(service_id)
  end

  def set_quote_request
    @quote_request = QuoteRequest.find(params[:id])
  end

  def load_quote_requests_for_current_role
    if user_signed_in?
      [current_user.quote_requests.includes(service: [:departure, :destination, :provider]).recent, false]
    else
      [QuoteRequest.joins(:service).where(services: { provider_id: current_provider.id })
                   .includes(:user, service: [:departure, :destination]).recent, true]
    end
  end

  def require_login_for_quote_requests
    return if user_signed_in? || provider_signed_in?
    redirect_to new_user_session_path, alert: "ログインしてください"
  end

  def authorize_quote_request!
    return if user_signed_in? && @quote_request.user_id == current_user.id
    return if provider_signed_in? && @quote_request.service.provider_id == current_provider.id
    redirect_to root_path, alert: "権限がありません"
  end

  def quote_request_params
    params.require(:quote_request).permit(:service_id, :message, :weight_kg, :volume_cbm, :quantity, :incoterm_id)
  end
end
