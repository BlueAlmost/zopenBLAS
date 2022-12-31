A = [1 -3 
     2  4 
     1 -1
    ]

B = [ 1  1 4
     2 -3 -1]
    
C = 0.3*ones(3,3);

alpha = 1.4;
beta = 13.0;

C_out = alpha*A*B + beta*C;

Xre = A
Xim = A
X = Xre + im*Xim;

Yre =  B
Yim =  B
Y = Yre + im*Yim;

Z = (0.2  - im*0.1) .* ones(3,3);

gamma = 3.0+im*3.2;
delta = 4.4 -im*3.2;
Z =  gamma*X*Y + delta*Z

