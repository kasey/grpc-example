#! /usr/bin/env bash

# create target directory for code gen
mkdir -p /build/echo

# build grpc service interfaces and protobufs
protoc -I/usr/local/include -I/build -I/go/src  -I/go/src/github.com/gengo/grpc-gateway/third_party/googleapis --go_out=Mgoogle/api/annotations.proto=github.com/gengo/grpc-gateway/third_party/googleapis/google/api,plugins=grpc:/build/echo /build/proto/echo.proto
# grpc-gateway code generation
protoc -I/usr/local/include -I/build -I/go/src -I/go/src/github.com/gengo/grpc-gateway/third_party/googleapis --grpc-gateway_out=logtostderr=true:/build/echo /build/proto/echo.proto
# generate swagger definitions
protoc -I/usr/local/include -I/build -I/go/src -I/go/src/github.com/gengo/grpc-gateway/third_party/googleapis --swagger_out=logtostderr=true:/build/echo /build/proto/echo.proto

# build go client and server binaries
mkdir -p /build/go-bin
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-s' -o /build/go-bin/echo-server github.com/kasey/grpc-example/server
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-s' -o /build/go-bin/echo-client github.com/kasey/grpc-example/client

# generate python grpc bindings for the client program
protoc -I/build -I/go/src/github.com/gengo/grpc-gateway/third_party/googleapis --python_out==Mgoogle/api/annotations.proto=github.com/gengo/grpc-gateway/third_party/googleapis/google/api:/build/py_proto --grpc_out=/build/py_proto --plugin=protoc-gen-grpc=`which grpc_python_plugin` /build/proto/echo.proto

# the gnerated code is placed into a folder reflecting the path of the .proto def
# eg we said to put the output in /build/py_proto, so it added a proto dir to maintain nesting
# we need to touch __init__.py inside that new folder to turn it into a python module so that
# the module can be imported by our client program
touch /build/py_proto/proto/__init__.py
