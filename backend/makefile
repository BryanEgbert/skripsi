unit_test:
	go test ./... -v -tags unit

test:
	GIN_MODE=release go test -v ./...

run: 
	go run cmd/main.go

bin:
	go build -o main cmd/main.go

tunnel:
	ssh -p 443 -R0:localhost:8080 a.pinggy.io