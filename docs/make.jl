using BaseMM
using Documenter

DocMeta.setdocmeta!(BaseMM, :DocTestSetup, :(using BaseMM); recursive=true)

makedocs(;
    modules=[BaseMM],
    authors="hendri54 <hendricksl@protonmail.com> and contributors",
    repo="https://github.com/hendri54/BaseMM.jl/blob/{commit}{path}#{line}",
    sitename="BaseMM.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
