.PHONY: test-images test

.DEFAULT_GOAL:= test-images

#RUBY := ruby2.4
RUBY := ruby
MAKE_TEST_IMAGES := make-test-images.rb
TRANSFORM_IMAGES := transform-images.rb
TESTDATADIR := testdata
TESTRESDIR := testresults
IMAGE_SET := image-set.txt

$(TESTDATADIR):
	mkdir -p $@

$(TESTRESDIR):
	mkdir -p $@

test-images: | $(TESTDATADIR)
	$(RUBY) $(MAKE_TEST_IMAGES) --output-directory $(TESTDATADIR) --image-set $(IMAGE_SET)

test: | $(TESTRESDIR)
	$(RUBY) $(TRANSFORM_IMAGES) --output-directory $(TESTRESDIR) --image-set $(IMAGE_SET)
