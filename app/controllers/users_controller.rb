class UsersController < ApplicationController
  def show
    @name = current_user.name
  end
end
