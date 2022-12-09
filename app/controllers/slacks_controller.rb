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
      if /^絵文字召喚[ ]+pink[ ]+[\s\S]+/.match(text)
        moji = text.gsub(/^絵文字召喚[ ]+pink[ ]+/, '')
        EmojiGenerator.generate_emoji(moji, { color: '#ff96d6' }) # Pink
      elsif /^絵文字召喚[ ]+black[ ]+[\s\S]+/.match(text)
        moji = text.gsub(/^絵文字召喚[ ]+black[ ]+/, '')
        EmojiGenerator.generate_emoji(moji, { border: 'white' })
      elsif /^絵文字召喚[ ]+((background=[\S]+|color=[\S]+|border=[\S]+)[ ]+)+[\s\S]+/.match(text)
        moji = text.gsub(/^絵文字召喚[ ]+((background=[\S]+|color=[\S]+|border=[\S]+)[ ]+)+/, '')
        background = text.slice(/background=[\S]+/)&.gsub(/background=/, '')
        border = text.slice(/border=[\S]+/)&.gsub(/border=/, '')
        color = text.slice(/color=[\S]+/)&.gsub(/color=/, '')
        EmojiGenerator.generate_emoji(moji, {
          background: background,
          border: border,
          color: color
        })
      elsif /^絵文字召喚[ ]+[\s\S]+/.match(text)
        moji = text.gsub(/^絵文字召喚[ ]+/, '')
        EmojiGenerator.generate_emoji(moji, { background: 'white' })
      end
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
