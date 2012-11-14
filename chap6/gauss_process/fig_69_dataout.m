1;
clear

global eta = [1 1];
%global eta = [1 0.01];
global theta0 = 0.5;

N = 30;

xl = linspace(-1, 1, N);

xs = zeros(2, N*N);
for x1 = 1:N
  for x2 = 1:N
    j = (x2-1)*N + x1;
    xs(:,j) = [x1; x2];
  endfor
endfor

function [retval] = ard_kernel(x1, x2)
  global eta;
  global theta0;
  sum = eta(1)*(x1(1)-x2(1))^2 + eta(2)*(x1(2)-x2(2))^2;
  retval = theta0 * exp(-1/2*sum);
endfunction

function [R] = big_rand(Mu, Cov)
  N = length(Mu);
%  matrix_type(Cov)
  L = chol(Cov, 'lower');
  z = randn(N,1);
%  z = stdnormal_rnd([N 1])
  R = Mu + L * z;
endfunction

k = @ard_kernel;

cov = outer(xs, xs, k);

bm = min(eig(cov));
if bm < 0
  beta = -bm
else
  beta = 0
endif

cov += eye(N*N)*beta;

R = big_rand(zeros(N*N,1), cov);
[xx, yy] = meshgrid(xl, xl);
x_ = reshape(xx, [N*N 1]);
y_ = reshape(yy, [N*N 1]);
z_ = R;
xyz = [x_ y_ z_];

save "fig69.dat" xyz -ascii -tabs
