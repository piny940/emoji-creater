require 'rmagick'

class EmojiGenerator
  FONT = 'app/assets/fonts/HackGen35ConsoleNFJ-Bold.ttf'
  IMAGE_SIZE = 200

  def self.generate_emoji(text, options)
    canvas = Magick::ImageList.new
    canvas.new_image(IMAGE_SIZE, IMAGE_SIZE) do |c|
      c.background_color = options[:background] || 'Transparent'
    end
    text = insert_new_line(text)
    drawing = Magick::Draw.new
    drawing.font = FONT
    drawing.pointsize = point_size(text)
    drawing.gravity = Magick::CenterGravity

    drawing.annotate(canvas, 0, 0, 0, 0, text) do |drawing|
      drawing.fill = options[:color] || 'black'
      drawing.stroke = options[:border] || 'Transparent'
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
  def self.point_size(text)
    tmp_image = Magick::ImageList.new
    tmp_image.new_image(IMAGE_SIZE, IMAGE_SIZE)
    drawing = Magick::Draw.new
    drawing.annotate(tmp_image, 0, 0, 0, 0, text) do |txt|
      txt.gravity = Magick::CenterGravity
      txt.pointsize = INITIAL_POINT_SIZE
      txt.fill = "#ffffff"
      txt.font = FONT
    end
    metrics = drawing.get_multiline_type_metrics(tmp_image, text)
    (INITIAL_POINT_SIZE * (IMAGE_SIZE - 10) / metrics.width).floor
  end
end
