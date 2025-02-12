class UsersController < ApplicationController
  def show
    @user = User.find_by!(name: params.fetch(:name))
  end
end
