class SlacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    slack_params = params[:slack]
    p slack_params
    return render json: {
    }, status: 400 if slack_params[:token] != ENV['SLACK_VERIFICATION_TOKEN']

    return render json: {
    }, status: 200 if slack_params[:event][:bot_id].present?

    text = slack_params[:event][:text]
    client = Slack::Web::Client.new
    client.chat_postMessage(
      channel: slack_params[:event][:channel],
      text: 'テスト',
      as_user: true
    )

    render json: {
    }, status: 200
  end
end
