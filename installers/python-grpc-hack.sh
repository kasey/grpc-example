protoc -I/go/src/github.com/gengo/grpc-gateway/third_party/googleapis --python_out=/usr/local/lib/python2.7/dist-packages/ --grpc_out=/usr/local/lib/python2.7/dist-packages/ --plugin=protoc-gen-grpc=`which grpc_python_plugin` /go/src/github.com/gengo/grpc-gateway/third_party/googleapis/google/api/annotations.proto
protoc -I/go/src/github.com/gengo/grpc-gateway/third_party/googleapis --python_out=/usr/local/lib/python2.7/dist-packages/ --grpc_out=/usr/local/lib/python2.7/dist-packages/ --plugin=protoc-gen-grpc=`which grpc_python_plugin` /go/src/github.com/gengo/grpc-gateway/third_party/googleapis/google/api/http.proto
touch /usr/local/lib/python2.7/dist-packages/google/__init__.py
touch /usr/local/lib/python2.7/dist-packages/google/api/__init__.py
