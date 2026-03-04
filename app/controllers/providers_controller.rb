class ProvidersController < ApplicationController
  before_action :authenticate_provider!, only: [:mypage]

  # 業者向け入口（ログイン・登録の選択）。認証不要
  def entry
    render :entry
  end

  # プロバイダー公開プロフィール（認証不要）。/providers/:id
  def show
    @provider = Provider.find(params[:id])
    @services = @provider.services.includes(:departure, :destination)
  end

  # 自分のマイページ（認証必須）。/mypage/provider
  def mypage
    @provider = current_provider
    @services = @provider.services.includes(:departure, :destination)
    render :show
  end
end
