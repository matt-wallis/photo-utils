.PHONY: tests

.DEFAULT_GOAL:= tests

RUBY := ruby2.3
ADD_ARROWS := add-arrows.rb
OUTDIR := out

$(OUTDIR):
	mkdir -p $@

tests: | $(OUTDIR)
	$(RUBY) $(ADD_ARROWS) --input testdata/map1.jpg --output out/map1.jpg --points ''
