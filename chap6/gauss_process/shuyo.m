1;

% PRML's synthetic data set
curve_fitting.x = [0.000000 0.111111 0.222222 0.333333 0.444444 0.555556 0.666667 0.777778 0.888889 1.000000];
curve_fitting.t = [0.349486 0.830839 1.007332 0.971507 0.133066 0.166823 -0.848307 -0.445686 -0.563567 0.261502];

% Gaussian kernel
global sigma = 0.1;

function [retval] = kernel(x1, x2)
  global sigma;
  retval = exp(-(x1-x2)^2/(2*sigma^2));
endfunction

% Gram matrix
K = outer(curve_fitting.x, curve_fitting.x, @kernel);

% covariance of marginal
beta = 25;
C_N = K + eye(10)/beta;  %% diag(10) → diagの挙動が違うのでeye(10)で代用

x = linspace(0, 1, 100);
% mean of posterior = regression function
m = outer(x, curve_fitting.x, @kernel) * inv(C_N) * curve_fitting.t';  %% solve(A) → inv(A)

%
% グラフ描画
%
clf
axis([-0.05 1.05 -1.1 1.1])
hold on  %% par(new=T)
plot(x, m)
plot(curve_fitting.x, curve_fitting.t, 'o')
hold off