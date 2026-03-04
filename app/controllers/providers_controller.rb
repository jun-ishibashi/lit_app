class ProvidersController < ApplicationController
  before_action :authenticate_provider!, only: [:show]

  # 業者向け入口（ログイン・登録の選択）。認証不要
  def entry
    render :entry
  end

  def show
    @provider = current_provider
    @services = @provider.services
  end
end
