package main

import (
    "log"
    "os"
    "strings"

    "golang.org/x/net/context"
    "google.golang.org/grpc"

    pb "github.com/kasey/grpc-example/echo/proto"
)

const (
    address = "echo-server:50051"
)

func main() {
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("couldn't connect to server %v", err)
    }
    defer conn.Close()
    c := pb.NewEchoClient(conn)

    if len(os.Args) < 2 {
        log.Fatalf("usage: echo-client <message>")
    }
    message := strings.Join(os.Args[1:], " ")

    r, err := c.Echo(context.Background(), &pb.StringMessage{Value: message})
    if err != nil {
        log.Fatalf("Could not call Echo: %v", err)
    }
    log.Printf("response: %s", r.Value)
}
