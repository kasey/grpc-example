docker run -v ${PWD}:/build -v ${GOPATH}/src:/go/src -e GOPATH=/go protobufz /build/built-within-docker.sh
