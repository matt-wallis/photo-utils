require 'optparse'
require 'ostruct'

module PhotoIndex
  class Options
    attr_reader :config

    # options is an array of symbols.
    # Each symbol must be the name of an instance method for 
    # processing the option. (e.g. :index_in)
    def initialize(*options)
      @config = OpenStruct.new
      opt_parser = OptionParser.new do |opts|
	options.each {|opt|
	  method(opt).call(opts, @config)
	}

	# No argument, shows at tail.  This will print an options summary.
	# Try it and see!
	opts.on_tail("-h", "--help", "Show this message") do
	  puts opts
	  exit
	end
      end
      opt_parser.parse!
    end
    def index_in(opts, config)
      config.index_in = "photolib.xml"	# default value
      opts.on("--index-in FILENAME", "Input XML") {|filename|
	config.index_in = filename
      }
    end
    def index_out(opts, config)
      config.index_out = "photolib.xml"	# default value
      opts.on("--index-out FILENAME", "Output XML") {|filename|
	config.index_out = filename
      }
    end
  end
end

