# using LinAlg

global x

x = [1.0,  2.0,  1.0] + im*[2, 1, 1];
y = [2.0, -2.0, -4.0] + im*[1, 3, 1];

theta = 0.6;

xx = cos(theta)*x  +  sin(theta)*y;
yy = -sin(theta)*x  +  cos(theta)*y;


println(x)
println(y)

println(xx)
println(yy)


