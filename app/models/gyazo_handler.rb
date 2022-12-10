require 'gyazo'

class GyazoHandler
  def self.upload(filename, title='emoji.png')
    gyazo = Gyazo::Client.new access_token: ENV['GYAZO_ACCESS_TOKEN']
    gyazo.upload imagefile: File.open(filename, 'r'), filename: title
  end
end
