#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

class Instagraph
  #@@_image = '/usr/local/wnw2/webroot/7a17f6d4.jpg'
  @@_image = ''
  @@_output = nil
  @@_prefix = 'IMG'
  @@_width = nil
  @@_height = nil
  @@_tmp = nil

  def initialize(image, output = 'out')
    if(File.exists?(image))
      @@_image = image
      @@_output = output
      (w, h) = `identify -format "%wx%h" #{@@_image}`.split(/\n/)[0].split(/x/)
      @@_width = w
      @@_height = h
    else
      #TODO
    end
  end

  def tempfile
    # copy original file and assign temporary name
    @@_tmp = @@_prefix + Time.now.strftime("%Y%m%d%H%M%S%3N");
    return system("/bin/cp #{@@_image} #{@@_tmp}")
  end

  def output
  #TODO
  end

  def execute( command )
    #remove newlines and convert single quotes to double to prevent errors
    command.gsub!(/(\r\n|\r|\n)/, '')
    command.gsub!("'", '"')
    # execute convert program
    return system(command)
  end

#### ACTION

  def colortone(input, color, level, type = 0)
    args1 = level
    args2 = 100 - level
    negate = type == 0? '-negate':''

    execute("convert #{input} \\( -clone 0 -fill '#{color}' -colorize 100% \\) \\( -clone 0 -colorspace gray #{negate} \\) -compose blend -define compose:args=#{args1},#{args2} -composite #{input}")
  end

  def border(input, color = 'black', width = 20)
    execute("convert #{input} -bordercolor #{color} -border #{width}x#{width} #{input}");
  end

  def frame(input, frame)
    execute("convert #{input} \\( '#{frame.to_s}' -resize #{@@_width}x#{@@_height}! -unsharp 1.5×1.0+1.5+0.02 \\) -flatten #{input}");
  end

  def vignette(input, color_1 = 'none', color_2 = 'black', crop_factor = 1.5)
    crop_x = (@@_width.to_i * crop_factor).floor
    crop_y = (@@_height.to_i * crop_factor).floor
  
    execute("convert \\( #{input} \\) \\( -size #{crop_x}x#{crop_y} radial-gradient:#{color_1}-#{color_2} -gravity center -crop #{@@_width}x#{@@_height}+0+0 +repage \\) -compose multiply -flatten #{input} ") 
  end


#### Filters
  def gotham
    tempfile()
    execute("convert #{@@_tmp} -modulate 120,10,100 -fill '#222b6d' -colorize 20 -gamma 0.5 -contrast -contrast #{@@_tmp}");
    border(@@_tmp)
  end

  def toaster
    tempfile()
    colortone(@@_tmp, '#330000', 100, 0)
    execute("convert #{@@_tmp} -modulate 150,80,100 -gamma 1.2 -contrast -contrast #{@@_tmp}");
    vignette(@@_tmp, 'none', 'LavenderBlush3');
    vignette(@@_tmp, '#ff9966', 'none');
  end

  def nashville
    tempfile()
    colortone(@@_tmp, '#222b6d', 100, 0)
    colortone(@@_tmp, '#f7daae', 100, 1)
  
    execute("convert #{@@_tmp} -contrast -modulate 100,150,100 -auto-gamma #{@@_tmp}")
    frame(@@_tmp, __method__)
  end

  def lomo
    tempfile()
    execute("convert #{@@_tmp} -channel R -level 33% -channel G -level 33% #{@@_tmp}")
    vignette(@@_tmp)
  end

  def kelvin
    tempfile()
    execute("convert \\( #{@@_tmp} -auto-gamma -modulate 120,50,100 \\) \\( -size #{@@_width}x#{@@_height} -fill 'rgba(255,153,0,0.5)' -draw 'rectangle 0,0 #{@@_width},#{@@_height}' \\) -compose multiply #{@@_tmp} ")
    frame(@@_tmp, __method__)
  end
end
