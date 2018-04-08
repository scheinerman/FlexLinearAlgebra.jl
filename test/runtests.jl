using FlexLinearAlgebra
using Base.Test

# write your own tests here
v = FlexConvert([4,5,6])
@test v+v == 2v
@test v-v == FlexVector(1:3)
@test dot(v,v) == 77
v[2] = 4
v[3] = 4
@test v == 4*FlexOnes(1:3)
@test v[-1] == 0

x = collect(1:5)
v = FlexConvert(x)
@test Vector(v) == x


M = FlexConvert(eye(Int,3))
@test M[1,1]==1

A = [1 3; 4 5]
B = [-1.0 3; 5 -1.5]
v = [2; 3]
AA = FlexConvert(A)
BB = FlexConvert(B)
vv = FlexConvert(v)
@test Vector(AA*vv) == A*v
@test Matrix(AA*BB) == Matrix(A)*Matrix(B)
@test (AA*BB)*vv == AA*(BB*vv)
@test Set(row_keys(AA)) == Set(row_keys(BB))
AA[1,3] = 2
@test size(AA) == (2,3)
