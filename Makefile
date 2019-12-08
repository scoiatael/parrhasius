dev:
	which goreman > /dev/null || go get github.com/mattn/goreman
	goreman -f=Procfile-dev -set-ports=false start


run:
	env APP_ENV=production ruby serve.rb

build:
	cd ext/gallery && npm run build
	cd ext/parrhasius && go install .

.PHONY: build run dev
