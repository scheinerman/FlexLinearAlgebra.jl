module FlexLinearAlgebra

import Base: (+), (-), (*), (==), dot, sum, (.*),
    getindex, setindex!, hash, show, keys, values, size,
    keytype, valtype, length, haskey, hash, Vector, Matrix, ctranspose


include("FlexVector.jl")
include("FlexMatrix.jl")
end # module
