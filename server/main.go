package main

import (
    "net"
    "log"

    "golang.org/x/net/context"
    "google.golang.org/grpc"

    pb "github.com/kasey/grpc-example/echo/proto"
)

type server struct{}

const (
    port = ":50051"
)

func (s *server) Echo(ctx context.Context, in *pb.StringMessage) (*pb.StringMessage, error) {
    return in, nil
}

func main() {
    lis, err := net.Listen("tcp", port)
    if err != nil {
        log.Fatalf("Failed to listen: %v", err)
    }

    s := grpc.NewServer()
    pb.RegisterEchoServer(s, &server{})
    s.Serve(lis)
}
