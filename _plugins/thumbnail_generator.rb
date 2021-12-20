require "mini_magick"
include MiniMagick

module Jekyll
  class ThumbnailGenerator < Generator
    safe true

    def generate(site)
       # posts = site.posts.docs.select { |post| post.data['thumbnail'] }
       files = site.static_files
       target_files = []
       files.each do |f|
        if f.path.match(/images\/photos/) 
          if f.path !~ /thumbs/
            target_files << f
          end
        end
       end
       resize_dimensions = Jekyll.configuration({})['thumbnail']['resize_dimensions']
       crop_dimensions = Jekyll.configuration({})['thumbnail']['crop_dimensions']
       target_files.each do |file|
         input_path = file.path
         thumb_path = "#{File.dirname(input_path)}/thumbs"
         output_path = "#{thumb_path}/#{file.name}"
         Dir.mkdir(thumb_path) unless Dir.exist?(thumb_path)
         if !File.exists?(output_path) || File.mtime(output_path) <= File.mtime(input_path)
            image = MiniMagick::Image.open(input_path)
            image.strip
            image.compress "JPEG2000"
            image.resize resize_dimensions
            image.gravity "center"
            image.crop crop_dimensions
            image.write output_path
         end
      end
    end
  end
end