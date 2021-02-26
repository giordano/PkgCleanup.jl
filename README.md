# PkgCleanup

[![Build Status](https://github.com/giordano/PkgCleanup.jl/workflows/CI/badge.svg)](https://github.com/giordano/PkgCleanup.jl/actions)

The [`Pkg.gc()`](https://julialang.github.io/Pkg.jl/v1/api/#Pkg.gc) command
garbage collects packages and artifacts that are no longer reachable, but will
not touch existing packages or artifacts requested by existing active
environments, which are listed in your `~/.julia/logs` directory.

`PkgCleanup.jl` provides a couple of functions which lets you interactively
remove active environments or artifacts you do not care about and that cannot be
removed by `Pkg.gc()`.

## Installation

To install the package, enter the Julia Pkg REPL mode with `]` and run the
command

```julia
add https://github.com/giordano/PkgCleanup.jl
```

## Usage

To load the package, run in the Julia REPL the command

```julia
using PkgCleanup
```

`PkgCleanup.jl` provides the following interactive functions:

* `PkgCleanup.artifacts()`: to remove unneeded `Artifacts.toml` from your
  `~/.julia/logs/artifact_usage.toml`;
* `PkgCleanup.manifests()`: to remove unneeded `Manifest.toml` from your
  `~/.julia/logs/manifest_usage.toml`.

Yes, that's it.

## License

The `PkgCleanup.jl` package is licensed under the MIT "Expat" License.  The
original author is Mosè Giordano.
