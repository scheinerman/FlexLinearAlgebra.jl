module FlexLinearAlgebra
using LinearAlgebra

import Base: (+), (-), (*), (==), sum, (.*),
    getindex, setindex!, hash, show, keys, values, size,
    keytype, valtype, length, haskey, hash, Vector, Matrix

import LinearAlgebra: dot, adjoint

include("FlexVector.jl")
include("FlexMatrix.jl")
end # module
