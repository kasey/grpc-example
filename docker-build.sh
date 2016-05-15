docker network create --driver bridge grpc &> /dev/null
docker build -t=protobufz .
