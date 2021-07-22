class ProvidersController < ApplicationController
  def show
    @name = current_provider.name
  end
end
