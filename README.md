# 🧠 gRPC Translation API

A high-performance translation microservice built with **Go**, **gRPC**, and **Docker**.
This service exposes a gRPC API to translate text between multiple languages using configurable translation vendors.

---

## 🇪🇸 Descripción (Español)

### 🚀 Introducción

Este proyecto implementa un servidor **gRPC** de traducción en Go.
Permite traducir texto entre varios idiomas usando diferentes proveedores (por ejemplo, Google Translate o DeepL).

### 🧱 Arquitectura

* **Lenguaje:** Go 1.23+
* **Framework RPC:** gRPC + Protocol Buffers
* **Contenedor:** Docker
* **Gestión:** Makefile con tareas automatizadas
* **Puerto expuesto:** `8765`

### 📂 Estructura del proyecto

```
.
├── proto/                     # Archivos .proto
│   └── translations.proto
├── server.go                  # Servidor principal gRPC
├── tests/                     # Tests funcionales en Go
│   └── translation_test.go
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
```

---

### 🧰 Comandos principales

| Comando          | Descripción                                         |
| ---------------- | --------------------------------------------------- |
| `make`           | Muestra la ayuda con todos los comandos disponibles |
| `make tidy`      | Ejecuta `go mod tidy`                               |
| `make generate`  | Genera el código gRPC a partir de los `.proto`      |
| `make build`     | Compila la imagen Docker y genera el binario        |
| `make up`        | Levanta el contenedor con el servidor gRPC          |
| `make test-go`   | Ejecuta los tests funcionales Go                    |
| `make grpc-test` | Ejecuta un test real del endpoint usando `grpcurl`  |

---

### 💬 Ejemplo de uso con grpcurl

Una vez el contenedor esté levantado (`make up`):

```bash
grpcurl --plaintext \
  -d '{"Text": "gRPC is a modern open source high performance Remote Procedure Call (RPC) framework that can run in any environment.", "SourceLang": 6, "TargetLang": 4}' \
  localhost:8765 translation.Translation/Translate
```

📜 **Respuesta esperada:**

```json
{
  "Text": "gRPC es un marco de RPC moderno y de alto rendimiento...",
  "SourceLang": 6,
  "TargetLang": 4,
  "BilledChars": 104
}
```

---

### 🧪 Ejecución de tests

Para correr los tests funcionales dentro del contenedor:

```bash
make test-go
```

---

## 🇬🇧 English Description

### 🚀 Introduction

This project implements a **gRPC translation server** written in Go.
It translates text between multiple languages using various providers (like Google Translate or DeepL).

### 🧱 Architecture

* **Language:** Go 1.23+
* **RPC Framework:** gRPC + Protocol Buffers
* **Containerization:** Docker
* **Automation:** Makefile
* **Port:** `8765`

### 📂 Project structure

```
.
├── proto/
│   └── translations.proto
├── server.go
├── tests/
│   └── translation_test.go
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
```

---

### 🧰 Main commands

| Command          | Description                                   |
| ---------------- | --------------------------------------------- |
| `make`           | Shows available commands                      |
| `make tidy`      | Runs `go mod tidy`                            |
| `make generate`  | Generates gRPC code from `.proto` files       |
| `make build`     | Builds the Docker image and binary            |
| `make up`        | Starts the gRPC server container              |
| `make test-go`   | Runs Go functional tests                      |
| `make grpc-test` | Performs a live endpoint test using `grpcurl` |

---

### 💬 Example usage with grpcurl

After running the server (`make up`):

```bash
grpcurl --plaintext \
  -d '{"Text": "gRPC is a modern open source high performance Remote Procedure Call (RPC) framework that can run in any environment.", "SourceLang": 6, "TargetLang": 4}' \
  localhost:8765 translation.Translation/Translate
```

📜 **Expected response:**

```json
{
  "Text": "gRPC is a modern open source high performance RPC framework...",
  "SourceLang": 6,
  "TargetLang": 4,
  "BilledChars": 104
}
```

---

### 🧪 Running tests

Run all Go functional tests inside Docker:

```bash
make test-go
```

---

## 🧑‍💻 Author

**Project:** `goland-grpc-api-translation-server`
**Container:** `translation-server`
**Port:** `8765`

---

## 🛠 Requirements

* Docker ≥ 24.x
* Docker Compose ≥ 2.x
* Make ≥ 4.3
* grpcurl ≥ 1.9.x (for manual tests)
