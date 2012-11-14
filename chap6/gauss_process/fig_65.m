1;
clear

% global theta = [0.7 14 0 0.03];
global theta = [1 64 0 0];
beta = 8;

x = linspace(-1, 1, 100);

data = load("curvefitting.txt");
data = data(1:7, :); %% 一番右から3つを捨てる
data_x = data(:,1);
data_t = data(:,2);

N = length(data_x);

function [retval] = gauss_kernel(x1, x2)
  retval = exp( -(x1-x2)^2 / (2*sigma^2) );
endfunction

function [retval] = my_kernel(x1, x2)
  global theta;
  tmp = -theta(2)/2*(x1-x2)^2;
  retval = theta(1)*exp(tmp) + theta(3) + theta(4)*x1'*x2;
endfunction

k = @my_kernel;

K = outer(data_x, data_x, k);
C_N = K + eye(N)/beta;  % 共分散行列10x10
% 共分散関数って何

m = zeros(100,1);
s2 = zeros(100,1);

for i = 1:100
  x_ = x(i);
  kvec = zeros(N,1);
  for j = 1:N
    kvec(j) = k(data_x(j), x_);
  endfor
  c = k(x_, x_) + 1/beta;
  m(i) = kvec' * inv(C_N) * data_t;
  s2(i) = c - kvec' * inv(C_N) * kvec;
endfor

graph = 1;
if graph == 1
  clf;
  hold on;
  title('Figure 6.8');

  axis([-1, 1, -3, 3]);

  plot(data_x, data_t, 'o');

  gray = [0.7 0.7 0.7];
%  fill([x fliplr(x)], [m'-2*s2' fliplr(m'+2*s2')], gray)
  plot(x, m, 'b:')
  plot(x, m+1*s2, 'g')
  plot(x, m-1*s2, 'g')
  plot(data_x, data_t, 'o')

  plot(x, sin(x*2*pi), 'r');

  hold off;
endif

%endfor
%endfor