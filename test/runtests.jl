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
