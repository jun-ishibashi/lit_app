class ProvidersController < ApplicationController
  def show
    @provider = current_provider
    @services = @provider.services
  end
end
