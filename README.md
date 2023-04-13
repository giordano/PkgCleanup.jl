# PkgCleanup

[![Build Status](https://github.com/giordano/PkgCleanup.jl/workflows/CI/badge.svg)](https://github.com/giordano/PkgCleanup.jl/actions)

The [`Pkg.gc()`](https://julialang.github.io/Pkg.jl/v1/api/#Pkg.gc) command
garbage collects packages and artifacts that are no longer reachable, but will
not touch existing packages or artifacts requested by existing active
environments, which are listed in your `~/.julia/logs` directory.  One option
for a more deep cleaning is to run `]gc --all`, but this will
remove... well... all packages.

If you prefer a more controlled way to clean package installations in your Julia
depot, you can remove the undesired manifests lingering in `~/.julia/logs`.
`PkgCleanup.jl` provides a couple of functions which let you interactively
remove active environments or artifacts you do not care about any longer but
cannot be removed by `Pkg.gc()`.

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

Execute the following line in your terminal to create a temp environment, install this package, and then clean up everything:

```bash
julia --startup-file=no --project=$(mktemp -d) -e 'using Pkg; Pkg.add(; url="https://github.com/giordano/PkgCleanup.jl"); using PkgCleanup, Dates; PkgCleanup.artifacts(); PkgCleanup.manifests(); Pkg.gc(; collect_delay=Dates.Day(0))'
```

### Demo

**NOTE**: deselect the entries you want to remove.

```julia
julia> using PkgCleanup

julia> PkgCleanup.manifests()
Select the Manifest.toml to keep in /home/user/.julia/logs/manifest_usage.toml
[press: d=done, a=all, n=none]
^  [X] /home/user/.julia/dev/BinaryBuilder/benchmark/Manifest.toml
   [X] /home/user/.julia/dev/JLLWrappers/Manifest.toml
   [X] /home/user/.julia/dev/PhysicalConstants/Manifest.toml
   [X] /home/user/.julia/dev/PkgCleanup/Manifest.toml
   [ ] /home/user/.julia/environments/v1.0/Manifest.toml
   [ ] /home/user/.julia/environments/v1.3/Manifest.toml
   [ ] /home/user/.julia/environments/v1.4/Manifest.toml
 > [ ] /home/user/.julia/environments/v1.5/Manifest.toml
   [X] /home/user/.julia/environments/v1.6/Manifest.toml
v  [X] /home/user/.julia/environments/v1.7/Manifest.toml

You are going to remove the following entries in /home/user/.julia/logs/manifest_usage.toml:
  * /home/user/.julia/environments/v1.0/Manifest.toml
  * /home/user/.julia/environments/v1.3/Manifest.toml
  * /home/user/.julia/environments/v1.4/Manifest.toml
  * /home/user/.julia/environments/v1.5/Manifest.toml
Do you confirm your choice? [Y/n]: y

To actually cleanup packages/artifacts installations, remember to run

    using Pkg
    Pkg.gc()

or, for a more in-depth cleaning,

    using Pkg
    using Dates
    Pkg.gc(; collect_delay=Dates.Day(0))
```

## License

The `PkgCleanup.jl` package is licensed under the MIT "Expat" License.  The
original author is Mosè Giordano.
