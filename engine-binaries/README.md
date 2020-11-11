# 📰 NEWS
- The layout of this repo changed a bit.
- I now provide 2 versions of the engine, one debug version and one release version.
- flutter-pi loads `libflutter_engine.so.debug`, or `libflutter_engine.so.release` if `--release` was given via cmdline.
- if `libflutter_engine.so.debug` or `libflutter_engine.so.release` could not be found by flutter-pi, it will try to load `libflutter_engine.so`.
- don't forget to delete your old `libflutter_engine.so`, since it's not overwritten when copying the new libraries
- `gen_snapshot_linux_x64` is for building the `app.so` to run your App in release mode. The binary must be executed on a Linux x64 machine. (If you're on Windows, just use WSL). Instructions WIP

# Engine Binaries
This branch contains precompiled flutter engine binaries, header files for use on the Raspberry Pi.

## Installation
If you want to install the flutter engine on your Pi, do the following steps:

1. Install the binaries:
```
$ git clone --depth 1 --branch engine-binaries https://github.com/ardera/flutter-pi.git engine-binaries
$ cd engine-binaries
$ sudo cp ./libflutter_engine.so.* ./icudtl.dat /usr/lib
$ sudo cp ./flutter_embedder.h /usr/include
```

## build parameters
The engine is built using tip-of-tree llvm/clang 10 and libcxx. The following args are passed to _gn_:
```bash
--target-triple arm-linux-gnueabihf
--linux-cpu arm
--embedder-for-target
--no-lto
--target-os linux
--arm-float-abi hard
```
