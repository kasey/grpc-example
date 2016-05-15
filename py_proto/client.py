import sys

from grpc.beta import implementations

from .proto import echo_pb2 as proto

_TIMEOUT_SECONDS = 1

def connect(host, port):
    channel = implementations.insecure_channel(host, port)
    return channel

def call_echo(channel, message):
    stub = proto.beta_create_Echo_stub(channel)
    response = stub.Echo(proto.StringMessage(value=message), _TIMEOUT_SECONDS)
    return response.value

def main(host, port, *echo_bits):
    channel = connect(host, port)
    message = ' '.join(*echo_bits)
    print "echo-server response=%s" % call_echo(channel, message)

if __name__ == '__main__':
    host = 'echo-server'
    port = 50051
    main(host, port, sys.argv[1:])
