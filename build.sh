docker run -v ${PWD}:/build -v ${GOPATH}/src:/go/src -e GOPATH=/go protobufz /build/built-within-docker.sh
cp go-bin/echo-server packaging

docker build -t=echo-server packaging
