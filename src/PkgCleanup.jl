module PkgCleanup

using Pkg, TOML, REPL.TerminalMenus, REPL.Terminals

"""
    logs_directory() -> String

Guess the path of the logs directory.
"""
logs_directory() =
    first(joinpath(d, "logs") for d in Pkg.depots() if isdir(joinpath(d, "logs")))

# Adapted from BinaryBuilder.jl/src/wizard/utils.jl
"""
    yn_prompt(question::AbstractString, default = :y;
              stdin::IO=Base.stdin,
              stdout::IO=Base.stdout,
              ) -> Bool

Perform a `[Y/n]` or `[y/N]` question loop, using `default` to choose between
the prompt styles, and looping until a proper response (e.g. `"y"`, `"yes"`,
`"n"` or `"no"`) is received.  Return `true` if "yes" is selected, `false` if
"no" is selected.
"""
function yn_prompt(question::AbstractString, default = :y;
                   stdin::IO=Base.stdin,
                   stdout::IO=Base.stdout,
                   )
    default in (:y, :n) || throw(ArgumentError("Default value must be either :y or :n"))
    ynstr = default == :y ? "[Y/n]" : "[y/N]"
    while true
        print(stdout, question, " ", ynstr, ": ")
        answer = lowercase(strip(readline(stdin)))
        if isempty(answer)
            return default === :y
        elseif answer == "y" || answer == "yes"
            return true
        elseif answer == "n" || answer == "no"
            return false
        else
            println(stdout, "Unrecognized answer. Answer `y` or `n`.")
        end
    end
end

function cleanup(path::String, what::String;
                 stdin::IO=Base.stdin,
                 stdout::IO=Base.stdout,
                 stderr::IO=Base.stderr,
                 )
    toml = TOML.parse(read(path, String))
    terminal = TTYTerminal("xterm", stdin, stdout, stderr)
    entries = sort!(collect(keys(toml)))
    select_menu = MultiSelectMenu(entries)
    select_menu.selected = Set(collect(eachindex(entries)))
    choices = request(terminal, "Select the $(what) to keep in $(path)", select_menu)
    selected_entries = entries[collect(choices)]
    filter!(e -> e.first ∈ selected_entries, toml)
    deleted = setdiff(entries, selected_entries)
    if !isempty(deleted)
        println(stdout)
        println(stdout, "You are going to remove the following entries in ", path, ":")
        for el in deleted
            println(stdout, "  * ", el)
        end
        if yn_prompt("Do you confirm your choice?"; stdin, stdout)
            open(path, "w") do io
                TOML.print(io, toml; sorted=true)
            end
        end
        println(stdout)
        println(stdout, "Remember to run Pkg.gc() to actually cleanup files!")
    end
    return nothing
end

"""
    PkgCleanup.artifacts()

Interactively select the `Artifacts.toml` files to keep in the list of active artifacts.
"""
artifacts(path=joinpath(logs_directory(), "artifact_usage.toml")) = cleanup(path, "Artifacts.toml")

"""
    PkgCleanup.manifests()

Interactively select the `Manifest.toml` files to keep in the list of active manifests.
"""
manifests(path=joinpath(logs_directory(), "manifest_usage.toml")) = cleanup(path, "Manifest.toml")

end
