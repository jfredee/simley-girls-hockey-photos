require "mini_magick"
require 'exifr/jpeg'
include MiniMagick 

class ProcessImages
  def initialize
    @basedir = 'images/photos'
    @resize_dimensions = '200x133^'
    @crop_dimensions = '200x133+0+0'
  end

  def run
    Dir.children(@basedir).each do |game_dir|
      puts "INITIAL game_dir is #{game_dir}"
      a_path = "#{@basedir}/#{game_dir}"
      if File.directory?(a_path)
        Dir.children("#{@basedir}/#{game_dir}").each do |image_file|
          puts "Looking at #{image_file}"
          next if ['..','.','.DS_Store'].include?(image_file)
          file_path = "#{@basedir}/#{game_dir}/#{image_file}" 
          #puts "FILE PATH is #{file_path}"
          #puts "File extname is #{File.extname(file_path)}"
          if ['.jpeg','.jpg','.JPEG'].include?(File.extname(file_path))
            if thumbnail_create?(file_path)
              puts "Create a thumbnail for #{file_path} "
              create_thumbnail(file_path)
            end
          end
        end
        create_data_file_for(game_dir)
      end
    end
    sync_to_s3
  end

  def create_data_file_for(game_directory)
    puts "Game directory is #{game_directory}"
    path = File.join(@basedir,game_directory)
    images = []

    game = { name: game_directory }
    Dir.children(path).each do |image_file|
      next if image_file == '.DS_Store'
      next if File.directory?(File.join(@basedir,game_directory,image_file))
      images.push({image_name: image_file})
      if image_file.match(/-thumb/)
        game[:thumbnail_photo] = image_file
      end
    end
    game[:images] = images
    game[:directory_name] = game_directory
    game[:title] = game_directory.split("_").collect(&:capitalize).join(" ")
    game[:thumbnail_photo] = images.first[:image_name] if !game[:thumbnail_photo]
    Dir.mkdir(File.join('_data','games')) unless Dir.exist?(File.join('_data','games'))
    game[:date] = EXIFR::JPEG.new(File.join(@basedir,game_directory,game[:thumbnail_photo])).exif.date_time_original
    datafile_path = File.join('_data','games',"#{game_directory}.yml")
    File.open(datafile_path,"w+") { |file| file.write(game.to_yaml) }

  end

  def sync_to_s3
    system "aws s3 sync #{@basedir} s3://simley-girls-hockey --acl public-read"
  end

  def thumbnail_create?(input_path)
    filename = File.basename(input_path)
    output_path = File.join(File.dirname(input_path),'thumbs',filename)
    puts "Looking for #{output_path}"
    return true if !File.exist?(output_path)
    return true if File.mtime(output_path) <= File.mtime(input_path)
  end

  def create_thumbnail(input_path)
    filename = File.basename(input_path)
    thumbnail_path = File.join(File.dirname(input_path),'thumbs')
    output_path = File.join(thumbnail_path,filename)
    Dir.mkdir(thumbnail_path) unless Dir.exist?(thumbnail_path)
    image = MiniMagick::Image.open(input_path)
    image.strip
    image.compress "JPEG2000"
    image.resize @resize_dimensions
    image.gravity "center"
    image.crop @crop_dimensions
    image.write output_path
  end

end