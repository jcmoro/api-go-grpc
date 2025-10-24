package main

import (
	"fmt"
	"log"
	"net"

	protos "github.com/truesch/grpc_getting_started/proto/translations"
	"github.com/truesch/grpc_getting_started/server"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {
	s := grpc.NewServer()
	trans := server.NewTranslation()
	protos.RegisterTranslationServer(s, trans)
	reflection.Register(s)

	lis, err := net.Listen("tcp", ":8765")
	if err != nil {
		log.Fatal(fmt.Println("Error starting tcp listener on port 8765", err))
	}

	log.Println("gRPC server listening on port 8765...")
	s.Serve(lis)
}
