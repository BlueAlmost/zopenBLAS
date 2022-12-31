# using LinAlg

global x

x = [1.0,  2.0,  1.0, -3.0]
y = [2.0, -2.0, -4.0, -3.0]

H = [1.1 -0.3
     2.1  3.2]

println(x)
println(y)

for i = 1:4
   println(i)

   q = H*[ x[i], y[i]]
   x[i] = q[1]
   y[i] = q[2]

end

println(x)
println(y)


