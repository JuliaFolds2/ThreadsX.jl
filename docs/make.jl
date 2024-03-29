using Documenter
using JSON
using ThreadsX

function should_push_preview(event_path = get(ENV, "GITHUB_EVENT_PATH", nothing))
    event_path === nothing && return false
    event = JSON.parsefile(event_path)
    pull_request = get(event, "pull_request", nothing)
    pull_request === nothing && return false
    labels = [x["name"] for x in pull_request["labels"]]
    yes = "push_preview" in labels
    if yes
        @info "Trying to push preview as label `push_preview` is specified." labels
    else
        @info "Not pushing preview as label `push_preview` is not specified." labels
    end
    return yes
end

makedocs(;
    modules=[ThreadsX],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    warnonly = true,
    sitename="ThreadsX.jl",
    authors="Takafumi Arakaki <aka.tkf@gmail.com>",
)

deploydocs(;
    repo="github.com/JuliaFolds2/ThreadsX.jl",
    push_preview = should_push_preview(),
)
