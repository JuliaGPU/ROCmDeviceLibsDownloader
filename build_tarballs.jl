# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ROCmDeviceLibsDownloader"
version = v"2.9.0"

# Collection of sources required to download ROCm-Device-Libs
sources = [
    FileSource("http://repo.radeon.com/rocm/apt/2.9.0/pool/main/r/rocm-device-libs/rocm-device-libs_1.0.0_amd64.deb",
               "94d1f143175c558e39ddccaefbab58e2a695bb9ffcc480102d610467e1a8914b"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
ar x rocm-device-libs_1.0.0_amd64.deb
tar xf data.tar.gz
mv opt/rocm/lib/ ../destdir/

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc),
    Linux(:x86_64, libc=:musl)
]

# The products that we will ensure are always built
products = [
    # TODO: A better way to emulate a FolderProduct would be nice
    FileProduct("lib/ockl.amdgcn.bc", :rocmdevlibdir),
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

