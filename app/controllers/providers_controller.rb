class ProvidersController < ApplicationController
  def show
    @provider = current_provider
  end
end
