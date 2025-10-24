# Etapa 1: build
FROM golang:1.23 AS builder

WORKDIR /app

# Instalar protoc
RUN apt-get update -qq && apt-get install -y -qq protobuf-compiler

# Instalar plugins para Go
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.33.0
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.4.0
ENV PATH="$PATH:$(go env GOPATH)/bin"

# Copiar dependencias
COPY go.mod go.sum ./
RUN go mod download

# Copiar proyecto
COPY . .

# Generar código Go desde proto
RUN mkdir -p proto/translations && \
    protoc -Iproto \
        --go_out=proto/translations --go_opt=paths=source_relative \
        --go-grpc_out=proto/translations --go-grpc_opt=paths=source_relative \
        proto/translations.proto

# Compilar binario (nombre único para evitar conflictos con carpetas)
RUN go build -o /app/translation-server ./main.go

# Etapa 2: runtime
FROM gcr.io/distroless/base-debian12

WORKDIR /app

# Copiar binario
COPY --from=builder /app/translation-server /app/server

# Copiar protos y tests si quieres ejecutar tests dentro
COPY --from=builder /app/proto /app/proto
COPY --from=builder /app/tests /app/tests

EXPOSE 8765

# Ejecutable final
ENTRYPOINT ["/app/server"]
