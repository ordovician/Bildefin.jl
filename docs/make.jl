using Bildefin
using Documenter

makedocs(;
    modules=[Bildefin],
    authors="Erik Engheim <erik.engheim@mac.com> and contributors",
    repo="https://github.com/ordovician/Bildefin.jl/blob/{commit}{path}#L{line}",
    sitename="Bildefin.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
