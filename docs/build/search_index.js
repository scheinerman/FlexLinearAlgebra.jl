var documenterSearchIndex = {"docs":
[{"location":"#FlexLinearAlgebra","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"","category":"section"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"A typical vector is indexed by integers 1, 2, 3, ..., n. The goal of this package is to create vectors (and eventually matrices) with arbitrary index sets.","category":"page"},{"location":"#The-FlexVector","page":"FlexLinearAlgebra","title":"The FlexVector","text":"","category":"section"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"A FlexVector behaves much like a linear algebra vector, but the index set can be arbitrary. A new, all zero-valued vector is created by calling FlexVector(dom) where dom is the index set. This can be any iterable Julia object (such as an Array, Set, etc.). By default, the zero values in this vector are of type Float64, but one can also invoke FlexVector{Int}(dom) and the resulting vector's values are Ints.","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"julia> using FlexLinearAlgebra\n\njulia> v = FlexVector(4:7)\nFlexVector{Int64,Float64}:\n  4 => 0.0\n  5 => 0.0\n  6 => 0.0\n  7 => 0.0\n\njulia> w = FlexVector{Int}([1,3,5])\nFlexVector{Int64,Int64}:\n  1 => 0\n  3 => 0\n  5 => 0\n\njulia> dom = [\"alpha\", \"bravo\", \"charlie\"]\n3-element Array{String,1}:\n \"alpha\"  \n \"bravo\"  \n \"charlie\"\n\njulia> FlexVector{Complex}(dom)\nFlexVector{String,Complex}:\n  alpha => 0 + 0im\n  bravo => 0 + 0im\n  charlie => 0 + 0im","category":"page"},{"location":"#Additional-constructors","page":"FlexLinearAlgebra","title":"Additional constructors","text":"","category":"section"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"The function FlexOnes can be used to generate a vector of all ones. Use either FlexOnes(dom) or FlexOnes(T,dom) like this:","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"julia> FlexOnes(3:5)\nFlexVector{Int64,Float64}:\n  3 => 1.0\n  4 => 1.0\n  5 => 1.0\n\njulia> FlexOnes(Complex,3:5)\nFlexVector{Int64,Complex}:\n  3 => 1 + 0im\n  4 => 1 + 0im\n  5 => 1 + 0im","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"The function FlexConvert converts an ordinary Vector into a FlexVector. The index set for the result is  1,2,...,n where n is the length of the vector.","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"julia> FlexConvert([1-2im,2+3im])\nFlexVector{Int64,Complex{Int64}}:\n  1 => 1 - 2im\n  2 => 2 + 3im","category":"page"},{"location":"#Accessing-elements-of-a-FlexVector","page":"FlexLinearAlgebra","title":"Accessing elements of a FlexVector","text":"","category":"section"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"The values held in a FlexVector may be accessed and modified using the usual Julia square-bracket notation:","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"julia> v[4]=7\n7\n\njulia> v\nFlexVector{Int64,Float64}:\n  4 => 7.0\n  5 => 0.0\n  6 => 0.0\n  7 => 0.0","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"The indices for a FlexVector v can be recovered using keys(v).","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"To delete an entry from a FlexVector use delete_entry!(v,k) where k is the index of the entry to be deleted. ","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"Note: It is not an error to access a key that is undefined for a given vector. Even if k is not a key, one may assign to v[k], in which case the vector is modified to include that value. One may also look up the value v[k] in which case zero is returned and the vector is not modified.","category":"page"},{"location":"#Convert-to-a-Julia-Vector","page":"FlexLinearAlgebra","title":"Convert to a Julia Vector","text":"","category":"section"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"If v is a FlexVector, then Vector(v) converts v into a Julia vector. The keys are lost and we simply have the values of v placed into a one-dimensional array.","category":"page"},{"location":"#Vector-arithmetic","page":"FlexLinearAlgebra","title":"Vector arithmetic","text":"","category":"section"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"Vector addition/subtraction and scalar multiplication are supported. If the domains of the two vectors are not the same, the resulting vector's domain is the union of the two domains. For example:","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"julia> v = FlexOnes(Complex{Int},1:4)\nFlexVector{Int64,Complex{Int64}}:\n  1 => 1 + 0im\n  2 => 1 + 0im\n  3 => 1 + 0im\n  4 => 1 + 0im\n\njulia> w = FlexOnes(3:6)\nFlexVector{Int64,Float64}:\n  3 => 1.0\n  4 => 1.0\n  5 => 1.0\n  6 => 1.0\n\njulia> v+w\nFlexVector{Int64,Complex{Float64}}:\n  1 => 1.0 + 0.0im\n  2 => 1.0 + 0.0im\n  3 => 2.0 + 0.0im\n  4 => 2.0 + 0.0im\n  5 => 1.0 + 0.0im\n  6 => 1.0 + 0.0im","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"Notice that the two domains overlap at keys 2 and 3, so the result of the addition at those values is 2.0 + 0.0im. At other keys, there's a tacit zero value taken from the vector that does not have that key.","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"The sum of the entries in a vector can be computed with sum(v). The dot product of two vectors is computed with dot. If v contains complex values, then dot(v,w) conjugates the values in v.","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"julia> v\nFlexVector{Int64,Float64}:\n  1 => 2.0\n  2 => 4.0\n\njulia> w\nFlexVector{Int64,Float64}:\n  1 => 3.0\n  2 => 5.0\n\njulia> dot(v,w)\n26.0\n\njulia> v = FlexConvert([1-2im,2+3im])\nFlexVector{Int64,Complex{Int64}}:\n  1 => 1 - 2im\n  2 => 2 + 3im\n\njulia> w = FlexConvert([-3im,5+2im])\nFlexVector{Int64,Complex{Int64}}:\n  1 => 0 - 3im\n  2 => 5 + 2im\n\njulia> dot(v,w)\n22 - 14im\n\njulia> dot(w,v)\n22 + 14im","category":"page"},{"location":"#The-FlexMatrix","page":"FlexLinearAlgebra","title":"The FlexMatrix","text":"","category":"section"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"A FlexMatrix is the 2-dimensional analogue of a FlexVector. Important functions include:","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"Arithmetic: Addition, subtraction, and multiplication (scalar, matrix-matrix, and matrix-vector).\nIndexing: Usual A[i,j] notation. Also see row_keys and col_keys to get a list for the row/column names.\nFlexConvert to convert a Julia matrix into a FlexMatrix.\nMatrix(A) to convert a FlexMatrix A into a Julia matrix.\ndelete_row!(A,r) and delete_col!(A,c) are used to delete the line of A specified.","category":"page"},{"location":"","page":"FlexLinearAlgebra","title":"FlexLinearAlgebra","text":"Note that assigning to a matrix A[i,j]=x will not fail. The set of row and column names will simply be expanded and extra slots filled with zeros.","category":"page"}]
}
