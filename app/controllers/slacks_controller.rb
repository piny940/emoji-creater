class SlacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    p params

    render json: {
      message: 'hoge'
    }
  end
end
