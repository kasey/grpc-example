GRPC Example Project
====================

This repo demonstrates a dockerized GRPC+grpc-gateway build process.  It could serve as a template for a project based on grpc, or just a place to see what parts make up such a thing.


Quickstart
----------
1. `./docker-build.sh` # see section *Build Container*
2. `./build.sh` # see section *GRPC and grpc-gateway*
3. `./run.sh` # see section *Running demo programs*
4. `docker run --net=grpc -v ${PWD}:/build protobufz /build/go-bin/echo-client I know you are, but what am I?`


Echo Service
------------

An example Echo service is implemented as a GRPC service, split into:

* `proto/echo.proto`: grpc service description w/ protobuf
* `server/main.go`: go implementation of the echo server
* `client/main.go`: go implementation of the echo client
* `py_proto/client.py`: python implementation of the python client


Build Container
---------------

Code generation and binary compilation takes place with the Docker container described by `Dockerfile`.

To build the Docker container, simply run `build-docker.sh`.  This will build the docker image locally in an image tagged `protobufz`, which is the name assumed by `run.sh` and `build.sh`.  `build-docker.sh` will also create a docker network with the name `grpc` which will be used by the example clients for service discovery (in both clients the grpc connect routine uses the hostname `echo-server`, which is what `run.sh` names the `echo-server` container when it runs, making the container discoverable via hostname within the `grpc` bridge network).


GRPC and grpc-gateway
---------------------

Now we're getting somewhere; time to do some grpc/protobuf code generation and build the example programs that use them.

A single build script `build.sh` starts the docker build container and runs `built-within-docker.sh`, which demonstrates how to do several things:

* build grpc service interfaces and protobufs.
* grpc-gateway code generation (via grpc-gateway).
* swagger spec generation (via grpc-gateway).
* building go client and server binaries.
  * note that a directory is created in the CWD called `go-bin`. This is so that build artifacts can be preserved after the docker container exits.  The `run.sh` examples assume this path was used.
* generating python grpc bindings for the client program.
  * also demonstrates the 'turn these bindings into a real module hack' which you might need to replicate depending on where your .proto file lives in a project tree.

Once the build script has finished, observe the following build artifacts:

  * `echo/proto` - directory created for go code generation artifacts:
    * `echo/proto/echo.pb.go`: grpc interfaces and protobuf structs. `server/main.go` and `client/main.go` show example usage.
    * `echo.pb.gw.go`: grpc-gateway generated proxy server.
    * `echo.swagger.json`: grpc-gateway generated swagger spec.
  * `py_proto/proto`: directory created for python code generation artifacts:
    * `py_proto/proto/echo_pb2.py`: grpc and protobuf classes for python. `py_proto/client.py` shows example usage.
    * `py_proto/proto/__init__.py`: created by the build script to ensure the module is treated as a module.
  * `go-bin`: `$GOPATH/bin` within the build container is mounted to this directory (created by the build script -- in .gitignore)

At this point you should be able to run the example programs.


Running demo programs
---------------------

Execute `run.sh` to start the server, and look at the contents of `run.sh` to see examples of running the go and python client programs.  As foreshadowed in the Build Container section, the example programs rely on a [Docker container bridge network](https://docs.docker.com/engine/userguide/networking/dockernetworks/) to find each other.  `build-docker.sh` takes care of creating such a network, named `grpc`.


References
----------

This repo is the product of me working through the READMEs, docs and tutorials for the protobuf, grpc and grpc-gateway projects, so all credit goes to them.  I strongly encourage looking through all these docs:

* Protocol Buffers:
  * Overview: https://developers.google.com/protocol-buffers/docs/overview#what-are-protocol-buffers
  * Language: https://developers.google.com/protocol-buffers/docs/proto3
  * For Go: https://developers.google.com/protocol-buffers/docs/gotutorial#why-use-protocol-buffers
  * For Python: https://developers.google.com/protocol-buffers/docs/pythontutorial#why-use-protocol-buffers
* GRPC
  * Docs/tutorial: http://www.grpc.io/docs/
  * Example repo: https://github.com/grpc/grpc-go/blob/master/examples/
* grpc-gateway
  * Good README, assumes some comfort with grpc: https://github.com/gengo/grpc-gateway


TODO
----
* Implement the full grpc-gateway json/rest api following the grpc-gateway readme.
* Work out an improved python client packaging flow.  The protoc logic for generating python module paths follows the nesting of the go modules which grpc-gateway vendors [googleapi protobufs](https://github.com/googleapis/googleapis) as `/google/api/*`, which causes the generated python module path to be eg `google/api/annotations_pb2.py`.  Dowstream the generated `echo_pb2` module imports this module as `google.api.annotations_pb2`, which means 1) you need to touch `__init__.py` google and api in the codegen target tree to make the module path importable 2) if there are other python modules installed under `google`, they need to live in the same import path so one doesn't occlude the other.  We are always in that reality since `google.protobuf` needs to be installed in order to generate the code in the first place!  The work-around I have for now is to generate the python proto modules as part of the docker image build process so that I can slip them into the google module and keep that step out of the `build.sh` cycle.  However, this means that the generated files only exist within the docker container.  Packaging the generated python code in a vendorable way outside of the container might require changes to the generated code to point the `import google.api...` at a more unique namespace to avoid the name collision.  See installers/python-grpc-hack.sh` for details on what's happening now.
