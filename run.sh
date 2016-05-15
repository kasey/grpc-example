# start the golang grpc server
docker run -d --net=grpc --name=echo-server -v ${PWD}:/build -p 50053:50051 protobufz /build/go-bin/echo-server

# go client run example:
# docker run --net=grpc -v ${PWD}:/build protobufz /build/go-bin/echo-client I know you are, but what am I?

# python client run example:
#docker run -it --net=grpc -v ${PWD}:/build -v ${GOPATH}/src:/go/src -e GOPATH=/go -e PYTHONPATH=/build:/build/py_proto:/build/py_proto/google/api/ protobufz python -m py_proto.client I know *you* are, but what am I?
