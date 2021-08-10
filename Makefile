default: build

build:
	@echo "Building frontend static assets to 'build'"
	yarn build

clean:
	@echo "Cleaning up all the generated files"
	@find . -name '*.test' | xargs rm -fv
	@find . -name '*~' | xargs rm -fv
	@rm -rvf m3

docker:
	@docker build -t myatsumon/testcicd .
