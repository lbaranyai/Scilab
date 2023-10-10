// Non-linear regression

// Read data
tmp = csvRead('example.csv',';','.','double');
xd = tmp(:,1);
yd = tmp(:,2);

// Show data
clf reset
plot(xd,yd,'ob');
xlabel('Time, h');
ylabel('Concentration, g/L');

// My function
// Equation: Y = A + B(1-exp(-X/C))
// Input
// (1) - coefficinets
// (2) - X data
function YP = mypredict(pv,xv)
    YP = pv(1) + pv(2)*(1 - exp(-xv/pv(3)) );
endfunction

// Initial guess
pv0 = [5;5;5];
// show initial curve
plot(xd,mypredict(pv0,xd),'-r');

// Cost function
// Input
// (1) - coefficients
// (2) - X data
// (3) - Y data
function DV = mycost(pv,xv,yv)
    DV = mypredict(pv,xv) - yv;
endfunction

// Curve fitting
[fopt,xopt,gopt] = leastsq(list(mycost,xd,yd),pv0);

// plot fitted curve
plot(xd,mypredict(xopt,xd),'-g');
legend(['Observed';'Initial guess';'Fitted curve'],pos=4,boxed=%F);
