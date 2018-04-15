
require 'nokogiri'

module PhotoIndex
  class Index
    def initialize
      @photos = {}	# key is absolute filename
    end
    def add(photo)
      @photos[photo.filename] = photo
    end
    def add_from_stdin
      ARGF.each {|line|
	file = File.absolute_path(line.strip)
	unless @photos.has_key?(file)
	  add(Photo.new(file))
	end
      }
    end
    def load_from_xml(fname)
      if File.exist?(fname)
	doc = File.open(fname) { |f| Nokogiri::XML(f) }
	doc.css('//photo').each { |ph|
	  add(Photo::from_xml(ph))
	  #puts ph['filename']
	}
      end
    end
    def save_to_xml(fname)
      File.open(fname, "w") {|f| f.write(to_xml)}
    end
    def to_xml
      builder = Nokogiri::XML::Builder.new {|xml|
	xml.photolib {|xml|
	  @photos.keys.sort.each {|k|
	    @photos[k].to_xml(xml)
	  }
	}
      }
      builder.to_xml
    end
    def collect_metadata
      @photos.values.each {|p| p.collect_metadata }
    end
  end
end
