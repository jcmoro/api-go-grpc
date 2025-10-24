package tests

import (
	"context"
	"log"
	"testing"
	"time"

	pb "github.com/truesch/grpc_getting_started/proto/translations"
	"google.golang.org/grpc"
)

// Cambia esto si tu contenedor no está en localhost
const grpcAddress = "localhost:8765"

func TestTranslationService(t *testing.T) {
	conn, err := grpc.Dial(grpcAddress, grpc.WithInsecure())
	if err != nil {
		t.Fatalf("No se pudo conectar al servidor gRPC: %v", err)
	}
	defer conn.Close()

	client := pb.NewTranslationClient(conn)

	tests := []struct {
		text       string
		sourceLang pb.Languages
		targetLang pb.Languages
		vendor     pb.Vendors
	}{
		{"Hola mundo", pb.Languages_ES, pb.Languages_EN, pb.Vendors_GoogleTranslate},
		{"Hello world", pb.Languages_EN, pb.Languages_ES, pb.Vendors_DeepL},
		{"Hallo Welt", pb.Languages_DE, pb.Languages_ES, pb.Vendors_GoogleTranslate},
	}

	for i, tt := range tests {
    	t.Run(tt.text, func(t *testing.T) {
    		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    		defer cancel()

    		resp, err := client.Translate(ctx, &pb.TranslationInput{
    			Text:       tt.text,
    			SourceLang: tt.sourceLang,
    			TargetLang: tt.targetLang,
    			Vendor:     &tt.vendor, // puntero
    		})
    		if err != nil {
    			t.Fatalf("Test %d falló: %v", i+1, err)
    		}

    		if resp.Text == "" {
    			t.Fatalf("Test %d falló: respuesta vacía", i+1)
    		}

    		log.Printf("Test %d OK: %s -> %s", i+1, tt.text, resp.Text)
    	})
    }
}
