class SlacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    p params
    return render json: {
    }, status: 400 if params[:token] != ENV['SLACK_VERIFICATION_TOKEN']

    render json: {
    }, status: 200
  end
end
