# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ROCmDeviceLibsDownloader"
version = v"1.8.3"

# Collection of sources required to build YasmBuilder
sources = [
    "http://repo.radeon.com/rocm/archive/apt_1.8.3.tar.bz2" =>
    "bb56a10af551f9012f09b9a6091d47ed165530daed4919346000f8994967179f",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
mv ./apt* apt/
mv apt/pool/main/r/rocm-device-libs/rocm-device-libs_0.0.1_amd64.deb .
ar x rocm-device-libs_0.0.1_amd64.deb
tar xf data.tar.gz
mv opt/rocm/lib/ ../destdir/

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc),
    Linux(:x86_64, :musl)
]

# The products that we will ensure are always built
products(prefix) = [
    # TODO: A better way to emulate a FolderProduct would be nice
    FileProduct(prefix, "lib/ockl.amdgcn.bc", :rocmdevlibdir),
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

