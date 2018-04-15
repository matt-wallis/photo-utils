require 'time'
# There are various tests that can be done on image files:
module PhotoIndex
  module MetaData
    class FileStat
      attr_reader :atime, :ctime, :mtime
      def initialize(atime, ctime,mtime)
	@atime = atime 
	@ctime = ctime 
	@mtime = mtime 
      end
      def to_xml(xml)
	xml.atime(atime.to_s)
	xml.ctime(ctime.to_s)
	xml.mtime(mtime.to_s)
      end
      def self.collect_metadata(fname)
	stat = File::Stat.new(fname)
	new(
	  stat.atime,
	  stat.ctime,
	  stat.mtime
	)
      end
      def self.from_xml(filestat)
	new(
	  filestat.at_css('atime').text,
	  filestat.at_css('ctime').text,
	  filestat.at_css('mtime').text
	)
      end
    end
    class Exif
    end
  end
end
