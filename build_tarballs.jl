# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ROCmDeviceLibsDownloader"
version = v"2.7.2"

# Collection of sources required to download ROCm-Device-Libs
sources = [
    FileSource("http://repo.radeon.com/rocm/apt/2.7.2/pool/main/r/rocm-device-libs/rocm-device-libs_0.0.1_amd64.deb",
               "9db86575acf665a641b20c23ca8104ea749bb75f1128c18718cec5ac4912a792"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
ar x rocm-device-libs_0.0.1_amd64.deb
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

