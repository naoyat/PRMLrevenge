1;
clear

data = load("curvefitting.txt");
data = data(1:7, :); %% 一番右から3つを捨てる
global data_x = data(:,1);
global data_t = data(:,2);
global N = length(data_x);


global theta = [0 0 0 0 0]

function [retval] = k(x1, x2)
  global theta;
  retval = theta(1)*exp(-theta(2)/2*(x1-x2)^2) + theta(3) + theta(4)*x1'*x2;
endfunction

% best_score = 99999999;
% best_theta = [0 0 0 0 0];

% [30] theta=[0.178833 21.9387 0.483427 0.0247159], beta=72.2331 ; score=14.9851
% [10] theta=[0.161072 20.2109 0.424446 0.0131939], beta=58.3131 ; score=11.546
% [1] theta=[0.348149 23.7672 0.372487 0.0830302], beta=56.1841 ; score=6.3566
% [248] theta=[0.374821 25.2201 1.26273 0.16372], beta=39.7545 ; score=18.6302
% [282] theta=[0.211474 16.75 0.605217 0.0193967], beta=83.2014 ; score=14.6122

global mu = [0.3 25 0 0.15 40];

theta = mu;
sigma = [0.15 10 1 0.3 20];

score = 99999999;
iter_max = 1000000;
for iter = 1:iter_max

th = zeros(5,1);
invalid = 0;
for j=1:5
%  th(j) = mu(j) + sigma(j)*randn;
  th(j) = theta(j) + sigma(j)*randn;
  if th(j) < 0
    invalid = 1;
    break;
  endif
endfor
if invalid == 1
  continue
endif

curr_theta = th;
curr_score = score68(curr_theta);

function [p] = P(e, en, t)
  if en < e
    p = 1;
  else
    p = exp((e - en)/t);
  endif
endfunction

if rand < P(score, curr_score, (iter_max-iter)/iter_max)
  score = curr_score;
  theta = curr_theta;

  printf("[%d] theta=[%g %g %g %g], beta=%g ; score=%g\n", iter, theta(1), theta(2), theta(3), theta(4), theta(5), score)
  fflush(stdout);

  K = outer(data_x', data_x', @k);
  C_N = K + eye(N)/theta(5);

  M_ = 100;
  xA = linspace(0, 1, M_);
  mA = zeros(M_, 1);
  sA = zeros(M_, 1);

  for i = 1:M_
    x_ = xA(i);
    kvec = zeros(N,1);
    for j = 1:N
      kvec(j) = k(data_x(j), x_);
    endfor
    c = k(x_, x_) + 1/theta(5);
    mA(i) = kvec' * inv(C_N) * data_t;
    sA(i) = sqrt(c - kvec' * inv(C_N) * kvec);
  endfor

%  figure(iter);

  clf reset;
  hold on;
  axis([-0.05, 1.05, -1.3, 1.3])

  plot(data_x, data_t, 'o');

  gray = [0.7 0.7 0.7];
  fill([xA fliplr(xA)], [mA'-2*sA' fliplr(mA'+2*sA')], gray)
  plot(xA, mA, 'b:')
  plot(data_x, data_t, 'o')

  plot(xA, sin(xA*2*pi), 'r');

  hold off;
  pause;
%  mu = (mu*9 + theta)/10;
endif

endfor

theta
score