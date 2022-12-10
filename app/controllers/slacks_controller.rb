class SlacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    slack_params = params[:slack]
    return render json: {
    }, status: 400 if slack_params[:token] != ENV['SLACK_VERIFICATION_TOKEN']

    return render json: {
    }, status: 200 if slack_params[:event][:bot_id].present?

    text = slack_params[:event][:text]

    return render json: {
    }, status: 200 unless /^絵文字召喚[ ]+[\s\S]+/.match(text)

    client = Slack::Web::Client.new

    begin
      EmojiGenerator.handle_command(text)
    rescue => error
      client.chat_postMessage(
        channel: slack_params[:event][:channel],
        text: error.message,
        as_user: true
      )
    else
      client.files_upload(
        channels: slack_params[:event][:channel],
        # channels: 'D04DXDEMW4W',
        as_user: true,
        file: Faraday::UploadIO.new('tmp/emoji.png', 'image/png'),
        title: 'emoji',
        filename: 'emoji.png',
      )
    ensure
      return render json: {}, status: 200
    end
  end
end
