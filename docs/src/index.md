# GalacticOptim.jl

GalacticOptim.jl is a package with a scope that is beyond your normal global optimization
package. GalacticOptim.jl seeks to bring together all of the optimization packages
it can find, local and global, into one unified Julia interface. This means, you
learn one package and you learn them all! GalacticOptim.jl adds a few high-level
features, such as integrating with automatic differentiation, to make its usage
fairly simple for most cases, while allowing all of the options in a single
unified interface.

## Installation

Assuming that you already have Julia correctly installed, it suffices to import
GalacticOptim.jl in the standard way:

```julia
import Pkg; Pkg.add("GalacticOptim")
```
The packages relevant to the core functionality of GalacticOptim.jl will be imported
accordingly and, in most cases, you do not have to worry about the manual
installation of dependencies. However, you will need to add the specific optimizer
packages.

## Overview of the Optimizers

| Package                  | Local Gradient-Based     | Local Hessian-Based      | Local Derivative-Free    | Local Constrained        | Global Unconstrained     | Global Constrained       |
|--------------------------|:------------------------:|:------------------------:|:------------------------:|:------------------------:|:------------------------:|:------------------------:|
| BlackBoxOptim            |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        |                        ❌ |
| CMAEvolutionaryStrategy |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        |                        ❌ |
| Evolutionary             |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        | 🟡                         |
| Flux                     | ✅                        |                        ❌ |                        ❌ |                        ❌ |                        ❌ |                        ❌ |
| GCMAES                   |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        |                        ❌ |
| MathOptInterface         | ✅                        | ✅                        | ✅                        | ✅                        | ✅                        |                        🟡 |
| MultistartOptimization   |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        |                        ❌ |
| Metaheuristics           |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        | 🟡                         |
| NOMAD                    |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        | 🟡                         |
| NLopt                    | ✅                        |                        ❌ | ✅                        | 🟡                         | ✅                        | 🟡                         |
| Nonconvex                | ✅                        | ✅                        | ✅                        | 🟡                         | ✅                        | 🟡                         |
| Optim                    | ✅                        | ✅                        | ✅                        | ✅                        | ✅                        | ✅                        |
| QuadDIRECT               |                        ❌ |                        ❌ |                        ❌ |                        ❌ | ✅                        |                        ❌ |

✅ = supported

🟡 = supported in downstream library but not yet implemented in `GalacticOptim`; PR to add this functionality are welcome

❌ = not supported
