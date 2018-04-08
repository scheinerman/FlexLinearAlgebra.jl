export FlexMatrix, row_keys, col_keys


immutable FlexMatrix{R<:Any,C<:Any,T<:Number}
    data::Dict{Tuple{R,C},T}
    function FlexMatrix{T}(rows,cols) where T<:Number
        R = eltype(rows)
        C = eltype(cols)
        RC = Tuple{R,C}
        d = Dict{RC,T}()
        for r in rows
            for c in cols
                d[r,c] = zero(T)
            end
        end
        new{R,C,T}(d)
    end
end

FlexMatrix(rows,cols) = FlexMatrix{Float64}(rows,cols)
FlexMatrix() = FlexMatrix(Int[],Int[])

function FlexOnes(T::Type,rows,cols)
    M = FlexMatrix{T}(rows,cols)
    for r in rows
        for c in cols
            M.data[r,c] = one(T)
        end
    end
    return M
end

FlexOnes(rows,cols) = FlexOnes(Float64,rows,cols)

function FlexConvert{T}(A::Matrix{T})
    r,c = size(A)
    M = FlexMatrix{T}(1:r, 1:c)
    for i=1:r
        for j=1:c
            M.data[i,j]=A[i,j]
        end
    end
    return M
end

keys(M::FlexMatrix) = keys(M.data)
values(M::FlexMatrix) = values(M.data)
valtype(M::FlexMatrix) = valtype(M.data)

"""
`row_keys(M::FlexMatrix)` returns a list of the keys to the
rows of `M`.
"""
function row_keys(M::FlexMatrix)
    firsts = unique( [ k[1] for k in keys(M) ] )
    try
        sort!(firsts)
    end
    return firsts
end

"""
`col_keys(M::FlexMatrix)` returns a list of the keys to the
columns of `M`.
"""
function col_keys(M::FlexMatrix)
    seconds = unique( [ k[2] for k in keys(M) ] )
    try
        sort!(seconds)
    end
    return seconds
end

function getindex{RC,T}(A::FlexMatrix{RC,T}, i, j)
    if haskey(A.data,(i,j))
        return A.data[i,j]
    end
    return zero(T)
end

setindex!(A::FlexMatrix,x,i,j) = setindex!(A.data,x,i,j)


function Matrix(A::FlexMatrix)
    rows = collect(row_keys(A))
    cols = collect(col_keys(A))
    try
        sort!(rows)
    end
    try
        sort!(cols)
    end
    r = length(rows)
    c = length(cols)

    R = Matrix{valtype(A)}(r,c)
    for i=1:r
        for j=1:c
            R[i,j] = A[rows[i],cols[j]]
        end
    end
    return R
end


function show{R,C,T}(io::IO, A::FlexMatrix{R,C,T})
    rows = row_keys(A)
    cols = col_keys(A)

    println(io,"FlexMatrix{($R,$C),$T}:")
    for r in rows
        for c in cols
            println("  $((r,c)) ==> $(A[r,c])")
        end
    end
    nothing
end

## Arithmetic

function _mush(A::FlexMatrix,B::FlexMatrix)
    rows = union(Set(row_keys(A)), Set(row_keys(B)))
    cols = union(Set(col_keys(A)), Set(col_keys(B)))
    TR = eltype(rows)
    TC = eltype(cols)

    TA = valtype(A)
    TB = valtype(B)
    TX = typeof(one(TA)+one(TB))

    M = FlexMatrix{TX}(rows,cols)
    return M
end

function (+)(A::FlexMatrix,B::FlexMatrix)
    M = _mush(A,B)
    for k in keys(M)
        M[k...] = A[k...]+B[k...]
    end
    return M
end

function (-)(A::FlexMatrix,B::FlexMatrix)
    M = _mush(A,B)
    for k in keys(M)
        M[k...] = A[k...]-B[k...]
    end
    return M
end

function Base.broadcast(::typeof(*),A::FlexMatrix,B::FlexMatrix)
    M = _mush(A,B)
    for k in keys(M)
        M[k...] = A[k...]*B[k...]
    end
    return M
end


function (*)(A::FlexMatrix, B::FlexMatrix)
    rowsA = row_keys(A)
    colsB = col_keys(B)

    TA = valtype(A)
    TB = valtype(B)
    TX = typeof(one(TA)+one(TB))

    M = FlexMatrix{TX}(rowsA,colsB)

    common = union( Set(col_keys(A)), Set(row_keys(B)) )

    for i in rowsA
        for j in colsB
            M[i,j] = sum( A[i,k]*B[k,j] for k in common )
        end
    end

    return M
end


function (*)(A::FlexMatrix, v::FlexVector)
    klist = row_keys(A)
    TA = valtype(A)
    Tv = valtype(v)
    Tw = typeof(one(TA)+one(Tv))
    w = FlexVector{Tw}(klist)

    sum_keys = union( Set(col_keys(A)), Set(keys(v)) )

    for k in klist
        w[k] = sum( A[k,j]*v[j] for j in sum_keys )
    end
    return w
end
