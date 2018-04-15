
module PhotoIndex
  class Photo
    attr_reader :filename
    def initialize(filename)
      @filename = filename
      @file_exists = true
      @metadata = {}
    end
    def self.from_xml(node)
      new(node['filename']).metadata_from_xml(node)
    end
    def metadata_from_xml(node)
      filestat = node.at_css('filestat')
      if filestat
	@metadata[:filestat] = MetaData::FileStat.from_xml(filestat)
      end
      self
    end

    def to_xml(xml)
      xml.photo(:filename => filename) {|xml|
	if @metadata[:filestat]
	  xml.filestat {|xml| @metadata[:filestat].to_xml(xml)}
	end
      }
    end
    def collect_metadata
      begin
	@metadata[:filestat] = MetaData::FileStat.collect_metadata(filename)
      rescue Errno::ENOENT
	@file_exists = false
      end
    end
  end
end
