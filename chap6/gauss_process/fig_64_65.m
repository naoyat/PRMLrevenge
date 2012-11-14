1;
clear

thetas_6_5 = [ 1 4 0 0;
               9 4 0 0;
               1 64 0 0;
               1 0.25 0 0;
               1 4 10 0;
               1 4 0 5 ];
global thetas = thetas_6_5(1,:);
global sigma = 1.2;
global theta = 1;

xmin = -1;
xmax = 1;
N = 100;
xs = linspace(xmin, xmax, N);

function [retval] = gauss_kernel(x1, x2)
  global sigma;
%  printf("exp(-(%g - %g)^2) = %g\n", x1, x2, exp(-(x1-x2)^2));
  retval = exp( -(x1-x2)^2 / (2*sigma^2) );
endfunction

function [retval] = ornstein_uhlenbeck(x1, x2)
  global theta;
  retval = exp(-theta*abs(x1-x2));
endfunction

function [retval] = my_kernel(x1, x2)
  global thetas;
  retval = thetas(1)*exp(-thetas(2)/2*(x1-x2)^2) + thetas(3) + thetas(4)*x1'*x2;
endfunction

function [R] = big_rand(Mu, Cov)
  N = length(Mu);
%  matrix_type(Cov)
  L = chol(Cov, 'lower');
  z = randn(N,1);
%  z = stdnormal_rnd([N 1])
  R = Mu + L * z;
endfunction

%k = @my_kernel;
k = @ornstein_uhlenbeck;

cov = outer(xs, xs, k);

bm = min(eig(cov));
if bm < 0
  beta = -bm
else
  beta = 0
endif

cov += eye(N)*beta;

graph = 1;
if graph == 1
  clf;
  hold on;
  axis([xmin xmax -3 3]);

  color = ['r';'g';'b';'k';'m'];
  for i = 1:5
    R = big_rand(zeros(N,1), cov);

    plot(xs, R, color(i))
  endfor

  hold off;
endif
