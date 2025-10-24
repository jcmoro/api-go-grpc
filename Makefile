# Makefile para Go + gRPC + Docker

.PHONY: help generate tidy up down clean test test-go

help:
	@echo "Comandos disponibles:"
	@echo "  make generate   → Genera código gRPC desde .proto"
	@echo "  make tidy       → Ejecuta go mod tidy y genera protos"
	@echo "  make up         → Levanta contenedor con binario compilado"
	@echo "  make down       → Detiene contenedores"
	@echo "  make clean      → Limpia binarios y proto generados"
	@echo "  make test       → Smoke test usando grpcurl"
	@echo "  make test-go    → Test funcional Go dentro del contenedor"

# Generar código gRPC desde proto
generate:
	@echo "Generando archivos .pb.go..."
	@docker run --rm -v $(PWD):/app -w /app golang:1.23 \
		bash -c "mkdir -p proto/translations && protoc -Iproto --go_out=proto/translations --go_opt=paths=source_relative --go-grpc_out=proto/translations --go-grpc_opt=paths=source_relative proto/translations.proto"

# Ejecuta go mod tidy
tidy: generate
	@echo "Ejecutando go mod tidy..."
	@docker run --rm -v $(PWD):/app -w /app golang:1.23 go mod tidy

# Levanta contenedor con binario compilado
up:
	@echo "Levantando contenedor con binario compilado..."
	docker compose up --build -d

# Detiene contenedor
down:
	docker compose down

# Limpia binarios y proto generados
clean:
	@echo "Limpiando..."
	rm -f translation-server
	rm -rf proto/translations/*.pb.go

# Smoke test con grpcurl
test:
	@echo "Probando endpoint Translation/Translate con grpcurl..."
	@docker run --rm --network host fullstorydev/grpcurl:latest \
		-plaintext \
		-d '{"Text":"Hola mundo","SourceLang":2,"TargetLang":6,"Vendor":0}' \
		localhost:8765 translation.Translation/Translate

# Test funcional Go dentro del contenedor
test-go:
	@echo "Ejecutando tests funcionales Go desde contenedor Go..."
	docker run --rm \
		--network host \
		-v $(PWD):/app \
		-w /app \
		golang:1.23 \
		go test ./tests -v

test-grpc:
	@echo "Probando endpoint Translation/Translate con grpcurl..."
	@docker run --rm --network host fullstorydev/grpcurl:latest \
		--plaintext \
		-d '{"Text":"gRPC is a modern open source high performance Remote Procedure Call (RPC) framework that can run in any environment.","SourceLang":6,"TargetLang":4}' \
		localhost:8765 translation.Translation/Translate
