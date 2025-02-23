# [Optim.jl](@id optim)
[`Optim`](https://github.com/JuliaNLSolvers/Optim.jl) is Julia package implementing various algorithm to perform univariate and multivariate optimization.

## Installation: GalacticOptimJL.jl

To use this package, install the GalacticOptimJL package:

```julia
import Pkg; Pkg.add("GalacticOptimJL")
```

## Methods

`Optim.jl` algorithms can be one of the following:

* `Optim.NelderMead()`
* `Optim.SimulatedAnnealing()`
* `Optim.ParticleSwarm()`
* `Optim.ConjugateGradient()`
* `Optim.GradientDescent()`
* `Optim.BFGS()`
* `Optim.LBFGS()`
* `Optim.NGMRES()`
* `Optim.OACCEL()`
* `Optim.NewtonTrustRegion()`
* `Optim.Newton()`
* `Optim.KrylovTrustRegion()`
* `Optim.ParticleSwarm()`
* `Optim.SAMIN()`

Each optimizer also takes special arguments which are outlined in the sections below.


The following special keyword arguments which are not covered by the common `solve` arguments can be used with Optim.jl optimizers:

* `x_tol`: Absolute tolerance in changes of the input vector `x`, in infinity norm. Defaults to `0.0`.
* `g_tol`: Absolute tolerance in the gradient, in infinity norm. Defaults to `1e-8`. For gradient free methods, this will control the main convergence tolerance, which is solver specific.
* `f_calls_limit`: A soft upper limit on the number of objective calls. Defaults to `0` (unlimited).
* `g_calls_limit`: A soft upper limit on the number of gradient calls. Defaults to `0` (unlimited).
* `h_calls_limit`: A soft upper limit on the number of Hessian calls. Defaults to `0` (unlimited).
* `allow_f_increases`: Allow steps that increase the objective value. Defaults to `false`. Note that, when setting this to `true`, the last iterate will be returned as the minimizer even if the objective increased.
* `store_trace`: Should a trace of the optimization algorithm's state be stored? Defaults to `false`.
* `show_trace`: Should a trace of the optimization algorithm's state be shown on `stdout`? Defaults to `false`.
* `extended_trace`: Save additional information. Solver dependent. Defaults to `false`.
* `trace_simplex`: Include the full simplex in the trace for `NelderMead`. Defaults to `false`.
* `show_every`: Trace output is printed every `show_every`th iteration.


For a more extensive documentation of all the algorithms and options please consult the 
[`Documentation`](https://julianlsolvers.github.io/Optim.jl/stable/#)

## Local Optimizer
### Local Constraint

`Optim.jl` implements the following local constraint algorithms:

- [`Optim.IPNewton()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/ipnewton/)
    * `linesearch` specifies the line search algorithm (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_linesearch.html))
        * available line search algorithms:
        * `HaegerZhang`
        * `MoreThuente`
        * `BackTracking`
        * `StrongWolfe`
        * `Static`
    * `μ0` specifies the initial barrier penalty coefficient as either a number or `:auto`
    * `show_linesearch` is an option to turn on linesearch verbosity.
    * Defaults:
        * `linesearch::Function = Optim.backtrack_constrained_grad`
        * `μ0::Union{Symbol,Number} = :auto`
        * `show_linesearch::Bool = false`

The Rosenbrock function can optimized using the `Optim.IPNewton()` as follows:

```julia
rosenbrock(x, p) =  (p[1] - x[1])^2 + p[2] * (x[2] - x[1]^2)^2
cons= (x,p) -> [x[1]^2 + x[2]^2]
x0 = zeros(2)
p  = [1.0,100.0]
prob = OptimizationFunction(rosenbrock, GalacticOptim.AutoForwardDiff();cons= cons)
prob = GalacticOptim.OptimizationProblem(prob, x0, p, lcons = [-5.0], ucons = [10.0])
sol = solve(prob, IPNewton())
```


### Derivative-Free
Derivative-free optimizers are optimizers that can be used even in cases where no derivatives or automatic differentiation is specified. While they tend to be less efficient than derivative-based optimizers, they can be easily applied to cases where defining derivatives is difficult. Note that while these methods do not support general constraints, all support bounds constraints via `lb` and `ub` in the `GalacticOptim.OptimizationProblem`.

`Optim.jl` implements the following derivative-free algorithms:

- [`Optim.NelderMead()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/nelder_mead/): **Nelder-Mead optimizer**

    * `solve(problem, NelderMead(parameters, initial_simplex))`
    * `parameters = AdaptiveParameters()` or `parameters = FixedParameters()`
    * `initial_simplex = AffineSimplexer()`
    * Defaults:
        * `parameters = AdaptiveParameters()`
        * `initial_simplex = AffineSimplexer()`

- [`Optim.SimulatedAnnealing()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/simulated_annealing/): **Simulated Annealing**

    * `solve(problem, SimulatedAnnealing(neighbor, T, p))`
    * `neighbor` is a mutating function of the current and proposed `x`
    * `T` is a function of the current iteration that returns a temperature
    * `p` is a function of the current temperature
    * Defaults:
        * `neighbor = default_neighbor!`
        * `T = default_temperature`
        * `p = kirkpatrick`

- [`Optim.ParticleSwarm()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/particle_swarm/)


The Rosenbrock function can optimized using the `Optim.NelderMead()` as follows:

```julia
rosenbrock(x, p) =  (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2
x0 = zeros(2)
p  = [1.0,100.0]
prob = GalacticOptim.OptimizationProblem(rosenbrock, x0, p)
sol = solve(prob, Optim.NelderMead())
```

### Gradient-Based
Gradient-based optimizers are optimizers which utilise the gradient information based on derivatives defined or automatic differentiation.


`Optim.jl` implements the following gradient-based algorithms:

- [`Optim.ConjugateGradient()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/cg/): **Conjugate Gradient Descent**

    * `solve(problem, ConjugateGradient(alphaguess, linesearch, eta, P, precondprep))`
    * `alphaguess` computes the initial step length (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_initialstep.html))
        * available initial step length procedures:
        * `InitialPrevious`
        * `InitialStatic`
        * `InitialHagerZhang`
        * `InitialQuadratic`
        * `InitialConstantChange`
    * `linesearch` specifies the line search algorithm (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_linesearch.html))
        * available line search algorithms:
        * `HaegerZhang`
        * `MoreThuente`
        * `BackTracking`
        * `StrongWolfe`
        * `Static`
    * `eta` determines the next step direction
    * `P` is an optional preconditioner (for more information, see [this source](https://julianlsolvers.github.io/Optim.jl/v0.9.3/algo/precondition/))
    * `precondpred` is used to update `P` as the state variable `x` changes
    * Defaults:
        * `alphaguess = LineSearches.InitialHagerZhang()`
        * `linesearch = LineSearches.HagerZhang()`
        * `eta = 0.4`
        * `P = nothing`
        * `precondprep = (P, x) -> nothing`

- [`Optim.GradientDescent()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/gradientdescent/): **Gradient Descent (a quasi-Newton solver)**

    * `solve(problem, GradientDescent(alphaguess, linesearch, P, precondprep))`
    * `alphaguess` computes the initial step length (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_initialstep.html))
        * available initial step length procedures:
        * `InitialPrevious`
        * `InitialStatic`
        * `InitialHagerZhang`
        * `InitialQuadratic`
        * `InitialConstantChange`
    * `linesearch` specifies the line search algorithm (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_linesearch.html))
        * available line search algorithms:
        * `HaegerZhang`
        * `MoreThuente`
        * `BackTracking`
        * `StrongWolfe`
        * `Static`
    * `P` is an optional preconditioner (for more information, see [this source](https://julianlsolvers.github.io/Optim.jl/v0.9.3/algo/precondition/))
    * `precondpred` is used to update `P` as the state variable `x` changes
    * Defaults:
        * `alphaguess = LineSearches.InitialPrevious()`
        * `linesearch = LineSearches.HagerZhang()`
        * `P = nothing`
        * `precondprep = (P, x) -> nothing`

- [`Optim.BFGS()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/lbfgs/): **Broyden-Fletcher-Goldfarb-Shanno algorithm**

     * `solve(problem, BFGS(alpaguess, linesearch, initial_invH, initial_stepnorm, manifold))`
     * `alphaguess` computes the initial step length (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_initialstep.html))
         * available initial step length procedures:
         * `InitialPrevious`
         * `InitialStatic`
         * `InitialHagerZhang`
         * `InitialQuadratic`
         * `InitialConstantChange`
     * `linesearch` specifies the line search algorithm (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_linesearch.html))
         * available line search algorithms:
         * `HaegerZhang`
         * `MoreThuente`
         * `BackTracking`
         * `StrongWolfe`
         * `Static`
    * `initial_invH` specifies an optional initial matrix
    * `initial_stepnorm` determines that `initial_invH` is an identity matrix scaled by the value of `initial_stepnorm` multiplied by the sup-norm of the gradient at the initial point
    * `manifold` specifies a (Riemannian) manifold on which the function is to be minimized (for more information, consult [this source](https://julianlsolvers.github.io/Optim.jl/stable/#algo/manifolds/))
        * available manifolds:
        * `Flat`
        * `Sphere`
        * `Stiefel`
        * meta-manifolds:
        * `PowerManifold`
        * `ProductManifold`
        * custom manifolds
    * Defaults:
        * `alphaguess = LineSearches.InitialStatic()`
        * `linesearch = LineSearches.HagerZhang()`
        * `initial_invH = nothing`
        * `initial_stepnorm = nothing`
        * `manifold = Flat()`

- [`Optim.LBFGS()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/lbfgs/): **Limited-memory Broyden-Fletcher-Goldfarb-Shanno algorithm**
    * `m` is the number of history points
    * `alphaguess` computes the initial step length (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_initialstep.html))
        * available initial step length procedures:
        * `InitialPrevious`
        * `InitialStatic`
        * `InitialHagerZhang`
        * `InitialQuadratic`
        * `InitialConstantChange`
    * `linesearch` specifies the line search algorithm (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_linesearch.html))
        * available line search algorithms:
        * `HaegerZhang`
        * `MoreThuente`
        * `BackTracking`
        * `StrongWolfe`
        * `Static`
    * `P` is an optional preconditioner (for more information, see [this source](https://julianlsolvers.github.io/Optim.jl/v0.9.3/algo/precondition/))
    * `precondpred` is used to update `P` as the state variable `x` changes
    * `manifold` specifies a (Riemannian) manifold on which the function is to be minimized (for more information, consult [this source](https://julianlsolvers.github.io/Optim.jl/stable/#algo/manifolds/))
        * available manifolds:
        * `Flat`
        * `Sphere`
        * `Stiefel`
        * meta-manifolds:
        * `PowerManifold`
        * `ProductManifold`
        * custom manifolds
    * `scaleinvH0`: whether to scale the initial Hessian approximation
    * Defaults:
        * `m = 10`
        * `alphaguess = LineSearches.InitialStatic()`
        * `linesearch = LineSearches.HagerZhang()`
        * `P = nothing`
        * `precondprep = (P, x) -> nothing`
        * `manifold = Flat()`
        * `scaleinvH0::Bool = true && (typeof(P) <: Nothing)`

- [`Optim.NGMRES()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/ngmres/)
- [`Optim.OACCEL()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/ngmres/)



The Rosenbrock function can optimized using the `Optim.LD_LBFGS()` as follows:

```julia
rosenbrock(x, p) =  (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2
x0 = zeros(2)
p  = [1.0,100.0]
optprob = OptimizationFunction(rosenbrock, GalacticOptim.AutoForwardDiff())
prob = GalacticOptim.OptimizationProblem(optprob, x0, p, lb=[-1.0, -1.0], ub=[0.8, 0.8])
sol = solve(prob, NLopt.LD_LBFGS())
```

### Hessian-Based Second Order
Hessian-based optimization methods are second order optimization
methods which use the direct computation of the Hessian. These can
converge faster but require fast and accurate methods for calulating
the Hessian in order to be appropriate.

`Optim.jl` implements the following hessian-based algorithms:


- [`Optim.NewtonTrustRegion()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/newton_trust_region/): **Newton Trust Region method**
    * `initial_delta`: The starting trust region radius
    * `delta_hat`: The largest allowable trust region radius
    * `eta`: When rho is at least eta, accept the step.
    * `rho_lower`: When rho is less than rho_lower, shrink the trust region.
    * `rho_upper`: When rho is greater than rho_upper, grow the trust region (though no greater than delta_hat).
    * Defaults:
        * `initial_delta = 1.0`
        * `delta_hat = 100.0`
        * `eta = 0.1`
        * `rho_lower = 0.25`
        * `rho_upper = 0.75`
- [`Optim.Newton()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/newton/): **Newton's method with line search**
    * `alphaguess` computes the initial step length (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_initialstep.html))
        * available initial step length procedures:
        * `InitialPrevious`
        * `InitialStatic`
        * `InitialHagerZhang`
        * `InitialQuadratic`
        * `InitialConstantChange`
    * `linesearch` specifies the line search algorithm (for more information, consult [this source](https://github.com/JuliaNLSolvers/LineSearches.jl) and [this example](https://julianlsolvers.github.io/LineSearches.jl/latest/examples/generated/optim_linesearch.html))
        * available line search algorithms:
        * `HaegerZhang`
        * `MoreThuente`
        * `BackTracking`
        * `StrongWolfe`
        * `Static`
    * Defaults:
        * `alphaguess = LineSearches.InitialStatic()`
        * `linesearch = LineSearches.HagerZhang()`


The Rosenbrock function can optimized using the `Optim.Newton()` as follows:

```julia
rosenbrock(x, p) =  (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2
x0 = zeros(2)
p  = [1.0,100.0]
f = OptimizationFunction(rosenbrock,ModelingToolkit.AutoModelingToolkit(),x0,p,grad=true,hess=true)
prob = GalacticOptim.OptimizationProblem(f,x0,p)
sol = solve(prob,Optim.Newton())
```


### Hessian-Free Second Order
Hessian-free methods are methods which perform second order optimization
by direct computation of Hessian-vector products (`Hv`) without requiring
the construction of the full Hessian. As such, these methods can perform
well for large second order optimization problems, but can require
special case when considering conditioning of the Hessian.

`Optim.jl` implements the following hessian-free algorithms:

* `Optim.KrylovTrustRegion()`: **A Newton-Krylov method with Trust Regions**
    * `initial_delta`: The starting trust region radius
    * `delta_hat`: The largest allowable trust region radius
    * `eta`: When rho is at least eta, accept the step.
    * `rho_lower`: When rho is less than rho_lower, shrink the trust region.
    * `rho_upper`: When rho is greater than rho_upper, grow the trust region (though no greater than delta_hat).
    * Defaults:
        * `initial_delta = 1.0`
        * `delta_hat = 100.0`
        * `eta = 0.1`
        * `rho_lower = 0.25`
        * `rho_upper = 0.75`

The Rosenbrock function can optimized using the `Optim.KrylovTrustRegion()` as follows:

```julia
rosenbrock(x, p) =  (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2
cons= (x,p) -> [x[1]^2 + x[2]^2]
x0 = zeros(2)
p  = [1.0,100.0]
optprob = OptimizationFunction(rosenbrock, GalacticOptim.AutoForwardDiff();cons= cons)
prob = GalacticOptim.OptimizationProblem(optprob, x0, p)
sol = solve(prob, Optim.KrylovTrustRegion())
```

## Global Optimizer


### Without Constraint Equations
The following method in [`Optim`](https://github.com/JuliaNLSolvers/Optim.jl) is performing global optimization on problems without
constraint equations. It works both with and without lower and upper constraints set by `lb` and `ub` in the `GalacticOptim.OptimizationProblem`.

- [`Optim.ParticleSwarm()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/particle_swarm/): **Particle Swarm Optimization**

    * `solve(problem, ParticleSwarm(lower, upper, n_particles))`
    * `lower`/`upper` are vectors of lower/upper bounds respectively
    * `n_particles` is the number of particles in the swarm
    * defaults to: `lower = []`, `upper = []`, `n_particles = 0`


The Rosenbrock function can optimized using the `Optim.ParticleSwarm()` as follows:

```julia
rosenbrock(x, p) =  (p[1] - x[1])^2 + p[2] * (x[2] - x[1]^2)^2
x0 = zeros(2)
p  = [1.0,100.0]
f = OptimizationFunction(rosenbrock)
prob = GalacticOptim.OptimizationProblem(f, x0, p, lb=[-1.0, -1.0], ub=[1.0, 1.0])
sol = solve(prob, Optim.ParticleSwarm(lower=prob.lb, upper= prob.ub, n_particles=100))
```

### With Constraint Equations
The following method in [`Optim`](https://github.com/JuliaNLSolvers/Optim.jl) is performing global optimization on problems with
constraint equations.

- [`Optim.SAMIN()`](https://julianlsolvers.github.io/Optim.jl/stable/#algo/samin/): **Simulated Annealing with bounds**

    * `solve(problem, SAMIN(nt, ns, rt, neps, f_tol, x_tol, coverage_ok, verbosity))`
    * Defaults:
      * `nt = 5`
      * `ns = 5`
      * `rt = 0.9`
      * `neps = 5`
      * `f_tol = 1e-12`
      * `x_tol = 1e-6`
      * `coverage_ok = false`
      * `verbosity = 0`

The Rosenbrock function can optimized using the `Optim.SAMIN()` as follows:

```julia
rosenbrock(x, p) =  (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2
x0 = zeros(2)
p  = [1.0,100.0]
f = OptimizationFunction(rosenbrock, GalacticOptim.AutoForwardDiff())
prob = GalacticOptim.OptimizationProblem(f, x0, p, lb=[-1.0, -1.0], ub=[1.0, 1.0])
sol = solve(prob, Optim.SAMIN())
```
