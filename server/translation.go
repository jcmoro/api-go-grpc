package server

import (
	"context"
	"fmt"

	pb "github.com/truesch/grpc_getting_started/proto/translations"
)

type Translation struct {
	pb.UnimplementedTranslationServer
}

func NewTranslation() *Translation {
	return &Translation{}
}

func (t *Translation) Translate(ctx context.Context, in *pb.TranslationInput) (*pb.TranslationOutput, error) {
	output := &pb.TranslationOutput{
		Text:        fmt.Sprintf("[translated %s→%s]: %s", in.SourceLang.String(), in.TargetLang.String(), in.Text),
		SourceLang:  in.SourceLang,
		TargetLang:  in.TargetLang,
		BilledChars: int32(len(in.Text)),
	}
	return output, nil
}
