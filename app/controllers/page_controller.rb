class PageController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def landing
    render layout: "application"
  end
end
