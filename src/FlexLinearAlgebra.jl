module FlexLinearAlgebra

import Base: (+), (-), (*), (==), dot, sum,
    getindex, setindex!, hash, show, keys, values,
    keytype, valtype, length, haskey, hash, Vector

export FlexVector, FlexOnes, FlexConvert

"""
A `FlexVector` is a vector whose entries are indexed by arbitrary
objects. To initialize to an all zeros vector, use one of the following:
+ `FlexVector{T}(dom)` where `dom` is an interable specifying the
    domain elements and `T` is the type of values held in the vector. The
    type of elements in `dom` determines the type of elements supported by
    this vector.
+ `FlexVector(dom)` assumes `T` is `Float64`.
+ `FlexVector()` assumes `T` is `Float64` and the domain type is `Int`.
"""

immutable FlexVector{S<:Any,T<:Number}
    data::Dict{S,T}
    function FlexVector{T}(dom) where T<:Number
        S = eltype(dom)
        d = Dict{S,T}()
        for x in dom
            d[x] = zero(T)
        end
        new{S,T}(d)
    end
end

FlexVector(dom) = FlexVector{Float64}(dom)
FlexVector() = FlexVector(Int[])

"""
`FlexOnes(T,dom)` creates an all 1s vector indexed by `dom`.
If `T` is missing, values default to `Float64`.
"""
function FlexOnes(T,dom)
    v = FlexVector{T}(dom)
    for x in dom
        v[x] = one(T)
    end
    return v
end

FlexOnes(dom) = FlexOnes(Float64,dom)

"""
`FlexConvert(vec)` converts the vector `vec` into a
`FlexVector`.
"""
function FlexConvert{T}(v::Vector{T})
    n = length(v)
    w = FlexVector{T}(1:n)
    for k=1:n
        w[k] = v[k]
    end
    return w
end

function Vector(v::FlexVector)
    klist = collect(keys(v))
    try
        sort!(klist)
    end
    n = length(klist)
    result = Vector{valtype(v)}(n)
    for k=1:n
        result[k] = v[klist[k]]
    end
    return result
end



keys(v::FlexVector) = keys(v.data)
values(v::FlexVector) = values(v.data)

keytype(v::FlexVector) = keytype(v.data)
valtype(v::FlexVector) = valtype(v.data)

length(v::FlexVector) = length(v.data)
haskey(v::FlexVector, k) = haskey(v.data,k)

setindex!(v::FlexVector, x, i) = setindex!(v.data,x,i)

function getindex{S,T}(v::FlexVector{S,T}, i)::T
    if haskey(v.data,i)
        return getindex(v.data,i)
    end
    return zero(T)
end

function show{S,T}(io::IO,v::FlexVector{S,T})
    klist = collect(keys(v))
    try
        sort!(klist)
    end
    println(io, "FlexVector{$S,$T}:")
    for k in klist
        println("  $k => $(v[k])")
    end
    nothing
end

hash(v::FlexVector, h) = hash(v.data)
(==)(v::FlexVector, w::FlexVector) = v.data == w.data


##### Arithmetic #####

# The _mush helper function mushes two vectors together.
function _mush(v::FlexVector,w::FlexVector)::FlexVector
    A = Set(keys(v))
    B = Set(keys(w))
    AB = union(A,B)
    Tv = valtype(v)
    Tw = valtype(w)
    Tx = typeof(one(Tv) + one(Tw))

    result = FlexVector{Tx}(AB)
    return result
end

function (+)(v::FlexVector, w::FlexVector)::FlexVector
    result = _mush(v,w)

    for k in keys(result)
        result[k] = v[k]+w[k]
    end

    return result
end

function (-)(v::FlexVector, w::FlexVector)::FlexVector
    result = _mush(v,w)

    for k in keys(result)
        result[k] = v[k]-w[k]
    end

    return result
end

# This is a quick-and-dirty implementation. Can probably do something
# more efficient but nothing here is efficient :-)
function dot(v::FlexVector,w::FlexVector)
    vw = _mush(v,w)
    for k in keys(vw)
        vw[k] = v[k]' * w[k]
    end
    return sum(values(vw))
end

function (*)(s::Number, v::FlexVector)::FlexVector
    if length(v) == 0
        return v
    end
    klist = collect(keys(v))
    x = s*v[klist[1]]

    sv = FlexVector{typeof(x)}(klist)  # place to hold the answer
    for k in klist
        sv[k] = s*v[k]
    end
    return sv
end

(-)(v::FlexVector) = -1 * v    # unary minus

sum(v::FlexVector) = sum(values(v))

end # module
