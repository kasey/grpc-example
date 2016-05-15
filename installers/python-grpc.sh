git clone https://github.com/grpc/grpc.git /build/grpc
cd /build/grpc
make grpc_python_plugin
cp bins/opt/grpc_python_plugin /usr/local/bin
