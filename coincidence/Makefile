.PHONY: test-images

.DEFAULT_GOAL:= test-images

RUBY := ruby2.4
MAKE_TEST_IMAGES := make-test-images.rb
OUTDIR := out

$(OUTDIR):
	mkdir -p $@

test-images: | $(OUTDIR)
	$(RUBY) $(MAKE_TEST_IMAGES) --output-directory $(OUTDIR)
