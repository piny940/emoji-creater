require 'rmagick'

class EmojiGenerator
  FONT = 'app/assets/fonts/mplus-2p-medium.otf'
  IMAGE_SIZE = 128
  INTERLINE_SPACING_PER_POINT_SIZE = -25 / 59.to_f

  def self.handle_command(command)
    if /^絵文字召喚[ ]+pink[ ]+[\s\S]+/.match(command)
      moji = command.gsub(/^絵文字召喚[ ]+pink[ ]+/, '')
      generate_emoji(moji, { color: '#ff96d6' }) # Pink
    elsif /^絵文字召喚[ ]+black[ ]+[\s\S]+/.match(command)
      moji = command.gsub(/^絵文字召喚[ ]+black[ ]+/, '')
      generate_emoji(moji, { border: 'white' })
    elsif /^絵文字召喚[ ]+((background=[\S]+|color=[\S]+|border=[\S]+)[ ]+)+[\s\S]+/.match(command)
      moji = command.gsub(/^絵文字召喚[ ]+((background=[\S]+|color=[\S]+|border=[\S]+)[ ]+)+/, '')
      background = command.slice(/background=[\S]+/)&.gsub(/background=/, '')
      border = command.slice(/border=[\S]+/)&.gsub(/border=/, '')
      color = command.slice(/color=[\S]+/)&.gsub(/color=/, '')
      generate_emoji(moji, {
        background: background,
        border: border,
        color: color
      })
    elsif /^絵文字召喚[ ]+[\s\S]+/.match(command)
      moji = command.gsub(/^絵文字召喚[ ]+/, '')
      generate_emoji(moji, { background: 'white' })
    end
  end

  def self.generate_emoji(text, options)
    canvas = Magick::ImageList.new
    canvas.new_image(IMAGE_SIZE, IMAGE_SIZE) do |c|
      c.background_color = options[:background] || 'Transparent'
    end
    text = insert_new_line(text)
    drawing = Magick::Draw.new

    drawing.annotate(canvas, 0, 0, 0, 0, text) do |txt|
      txt.fill = options[:color] || 'black'
      txt.stroke = options[:border] || 'Transparent'
      txt.font = FONT
      txt.pointsize = point_size(text)
      txt.gravity = Magick::CenterGravity
      txt.interline_spacing = interline_spacing(text)
    end

    canvas.write('tmp/emoji.png')
  end

  def self.insert_new_line(text)
    if text.length <= 3
      return text
    elsif text.length == 4
      tmp = text
      return tmp.insert(2, "\n")
    elsif text.length == 5 || text.length == 6
      tmp = text
      return tmp.insert(3, "\n")
    elsif 7 <= text.length && text.length <= 9
      tmp = text
      tmp.insert(3, "\n")
      tmp.insert(7, "\n")
      return tmp
    elsif 10 <= text.length && text.length <= 12
      tmp = text
      tmp.insert(4, "\n")
      tmp.insert(9, "\n")
      return tmp
    elsif 13 <= text.length && text.length <= 16
      tmp = text
      tmp.insert(4, "\n")
      tmp.insert(9, "\n")
      tmp.insert(14, "\n")
      return tmp
    elsif 17 <= text.length && text.length <= 20
      tmp = text
      tmp.insert(5, "\n")
      tmp.insert(11, "\n")
      tmp.insert(17, "\n")
      return tmp
    elsif 20 <= text.length
      tmp = text
      tmp.insert(5, "\n")
      tmp.insert(11, "\n")
      tmp.insert(17, "\n")
      tmp.insert(23, "\n")
      return tmp
    end
  end

  INITIAL_POINT_SIZE = 50
  INITIAL_INTERLINE_SPACING = -25
  def self.point_size(text)
    if text.length == 1
      return 125
    end
    tmp_image = Magick::ImageList.new
    tmp_image.new_image(IMAGE_SIZE, IMAGE_SIZE)
    drawing = Magick::Draw.new

    drawing.annotate(tmp_image, 0, 0, 0, 0, text) do |txt|
      txt.gravity = Magick::CenterGravity
      txt.pointsize = INITIAL_POINT_SIZE
      txt.fill = "#ffffff"
      txt.font = FONT
      txt.interline_spacing = INITIAL_INTERLINE_SPACING
    end

    metrics = drawing.get_multiline_type_metrics(tmp_image, text)
    [
      (INITIAL_POINT_SIZE * (IMAGE_SIZE - 10) / metrics.width).floor,
      (INITIAL_POINT_SIZE * IMAGE_SIZE / metrics.height).floor
    ].min
  end

  def self.interline_spacing(text)
    INTERLINE_SPACING_PER_POINT_SIZE * point_size(text)
  end
end
