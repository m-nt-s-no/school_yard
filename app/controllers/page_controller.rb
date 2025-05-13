class PageController < ApplicationController
  # NOTE: nice job using a seperate controller for landing page
  
  skip_before_action :authenticate_user!, only: [:landing]

  def landing
    render layout: "application"
  end
end
