ICED=node_modules/.bin/iced
BUILD_STAMP=build-stamp
UGLIFYJS=node_modules/.bin/uglifyjs
BROWSERIFY=node_modules/.bin/browserify

default: build
all: build

lib/%.js: src/%.iced
	$(ICED) -I browserify -c -o `dirname $@` $<

BROWSER=browser/icejax.js

build: $(BUILD_STAMP) release

$(BUILD_STAMP) : lib/main.js \
	lib/icejax.js
	date > $(BUILD_STAMP)

$(BROWSER): $(BUILD_STAMP)
	$(BROWSERIFY) -s icejax lib/main.js > $@

release: $(BROWSER)
	V=`jsonpipe < package.json | grep version | awk '{ print $$2 }' | sed -e s/\"//g` ; \
	cp $(BROWSER) rel/icejax-$$V.js ; \
	$(UGLIFYJS) -c < rel/icejax-$$V.js > rel/icejax-$$V-min.js

clean:
	rm -rf lib/* browser/* rel/* $(BUILD_STAMP)

.PHONY: clean release build

