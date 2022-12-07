class SlacksController < ApplicationController
  def create
    if (params[:token])
    p params
    render json: {
      
    }
  end
end
