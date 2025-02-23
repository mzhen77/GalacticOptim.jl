using Documenter, GalacticOptim

makedocs(
    sitename="GalacticOptim.jl",
    authors="Chris Rackauckas, Vaibhav Kumar Dixit et al.",
    clean=true,
    doctest=false,
    modules=[GalacticOptim,GalacticOptim.SciMLBase],

    format=Documenter.HTML(analytics = "UA-90474609-3",
                           assets=["assets/favicon.ico"],
                           canonical="https://galacticoptim.sciml.ai/stable/"),

    pages=[
        "GalacticOptim.jl: Unified Global Optimization Package" => "index.md",

        "Tutorials" => [
            "Basic usage" => "tutorials/intro.md",
            "Rosenbrock function" => "tutorials/rosenbrock.md",
            "Minibatch" => "tutorials/minibatch.md",
            "Symbolic Modeling" => "tutorials/symbolic.md"
        ],

        "API" => [
            "OptimizationProblem" => "API/optimization_problem.md",
            "OptimizationFunction" => "API/optimization_function.md",
            "solve" => "API/solve.md",
            "ModelingToolkit Integration" => "API/modelingtoolkit.md"
        ],
        "Optimizer Packages" => [
            "BlackBoxOptim.jl" => "optimization_packages/blackboxoptim.md",
            "CMAEvolutionStrategy.jl" => "optimization_packages/cmaevolutionstrategy.md",
            "Evolutionary.jl" => "optimization_packages/evolutionary.md",
            "Flux.jl" => "optimization_packages/flux.md",
            "GCMAES.jl" => "optimization_packages/gcmaes.md",
            "MathOptInterface.jl" => "optimization_packages/mathoptinterface.md",
            "MultistartOptimization.jl" => "optimization_packages/multistartoptimization.md",
            "Metaheuristics.jl" => "optimization_packages/metaheuristics.md",
            "NOMAD.jl" => "optimization_packages/nomad.md",
            "NLopt.jl" => "optimization_packages/nlopt.md",
            "Nonconvex.jl" => "optimization_packages/nonconvex.md",
            "Optim.jl" => "optimization_packages/optim.md",
            "QuadDIRECT.jl" => "optimization_packages/quaddirect.md"
        ],
    ]
)

deploydocs(
    repo="github.com/SciML/GalacticOptim.jl";
    push_preview=true
)
