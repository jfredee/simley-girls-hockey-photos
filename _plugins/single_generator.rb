# module Jekyll
#   class SinglePageGenerator < Jekyll::Generator
#     safe true

#     def generate(site)
#       puts "Starting to generate"
#       site.static_files.each do |single_photo, posts|
#         puts "Working on #{single_photo.name}"
#         next if single_photo.path.match(/thumbs/)
#         site.pages << SinglePhotoPage.new(site, single_photo, posts)
#       end
#     end
#   end

#   # Subclass of `Jekyll::Page` with custom method definitions.
#   class SinglePhotoPage < Jekyll::Page
#     def initialize(site, single_photo, posts)
#       @site = site             # the current site instance.
#       @base = site.source      # path to the source directory.
#       puts "The base is #{@base}"
#       @dir  = 'single_photos'         # the directory the page will reside in.
#       @collection = 'single_photos'

#       # All pages have the same filename, so define attributes straight away.
#       @basename = single_photo.basename      # filename without the extension.
#       @ext      = '.html'      # the extension.
#       @name     = @basename + @ext # basically @basename + @ext.

#       @content = %{---
# layout: photo_single
# ---
# } 

#       # Initialize data hash with a key pointing to all posts under current category.
#       # This allows accessing the list in a template via `page.linked_docs`.
#       @data = {
#        #'linked_docs' => posts
#       }

#       # Look up front matter defaults scoped to type `categories`, if given key
#       # doesn't exist in the `data` hash.
#       # data.default_proc = proc do |_, key|
#       #   site.frontmatter_defaults.find(relative_path, :single_photos, key)
#       # end
#     end

#     # Placeholders that are used in constructing page URL.
#     def url_placeholders
#       {
#         :category => @dir,
#         :basename   => basename,
#         :output_ext => output_ext,
#       }
#     end
#   end
# end