.PHONY: all

.PHONY: inout
.DEFAULT_GOAL := all
RUBY := ruby -I ../lib

XML1 := inout/a.xml
XML2 := inout/b.xml

inout:
	find /home/matt/Pictures -iname '*.jpg' | $(RUBY) ../bin/add_files.rb --index-in basic-copy/input.xml --index-out $(XML1)
	$(RUBY) ../bin/copy.rb --index-in $(XML1) --index-out $(XML2)
	diff $(XML1) $(XML2)

all: inout
	$(RUBY) all-tests.rb

# Run a single test (e.g. basic-network.rb) like this:
#
#   make test=basic-network one
#
one:
	$(RUBY) $(test).rb
