using GalacticNOMAD, GalacticOptim
using Test

@testset "GalacticNOMAD.jl" begin
    rosenbrock(x, p) = (p[1] - x[1])^2 + p[2] * (x[2] - x[1]^2)^2
    x0 = zeros(2)
    _p = [1.0, 100.0]
    l1 = rosenbrock(x0, _p)

    f = OptimizationFunction(rosenbrock)

    prob = OptimizationProblem(f, x0, _p)
    sol = GalacticOptim.solve(prob, NOMADOpt())
    @test 10 * sol.minimum < l1

    prob = OptimizationProblem(f, x0, _p; lb=[-1.0, -1.0], ub=[1.5, 1.5])
    sol = GalacticOptim.solve(prob, NOMADOpt())
    @test 10 * sol.minimum < l1
end
