using GalacticSpeedMapping, GalacticOptim, ForwardDiff
using Test

@testset "GalacticSpeedMapping.jl" begin
    rosenbrock(x, p) = (p[1] - x[1])^2 + p[2] * (x[2] - x[1]^2)^2
    x0 = zeros(2)
    _p = [1.0, 100.0]
    l1 = rosenbrock(x0, _p)
    f = OptimizationFunction(rosenbrock, GalacticOptim.AutoForwardDiff())
    prob = OptimizationProblem(f, x0, _p)
    sol = solve(prob, SpeedMappingOpt())
    @test 10 * sol.minimum < l1

    prob = OptimizationProblem(f, x0, _p; lb=[-1.0, -1.0], ub=[1.5, 1.5])
    sol = solve(prob, SpeedMappingOpt())
    @test 10 * sol.minimum < l1

    f = OptimizationFunction(rosenbrock)
    prob = OptimizationProblem(f, x0, _p)
    sol = solve(prob, SpeedMappingOpt())
    @test 10 * sol.minimum < l1

    prob = OptimizationProblem(f, x0, _p; lb=[-1.0, -1.0], ub=[1.5, 1.5])
    sol = solve(prob, SpeedMappingOpt())
    @test 10 * sol.minimum < l1
end
