docker run -v ${PWD}:/build -v ${GOPATH}/src:/go/src -e GOPATH=/go protobufz /build/built-within-docker.sh
REV=`git rev-parse HEAD`
cp go-bin/echo-server packaging

TAG="${DOCKER_REGISTRY}echo:${REV}"
docker build -t=$TAG packaging
echo "ECHO_IMAGE=${TAG}"
