class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:name, :introduction, :user_type_id, :product_id, :service_type_id])
  end

  # 日付パラメータを安全にパース。不正な文字列では nil を返す
  def safe_date(param)
    return nil if param.blank?
    Date.parse(param.to_s)
  rescue ArgumentError
    nil
  end
end
