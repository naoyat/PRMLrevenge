
function [score] = eval68(theta)
  global data_x;
  global data_t;
  global N;
  global mu;

  M = 6;
  x = linspace(0, 1, M);

  K = outer(data_x', data_x', @k);
  C_N = K + eye(N)/theta(5);  % 10x10

  m = zeros(M,1);
  s = zeros(M,1);
  sine = sin(x*2*pi);

  for i = 1:M
    x_ = x(i);
    kvec = zeros(N,1);
    for j = 1:N
      kvec(j) = k(data_x(j), x_);
    endfor
    c = k(x_, x_) + 1/theta(5);
    kCN = kvec' * inv(C_N);
    m(i) = kCN * data_t;
    s(i) = sqrt(c - kCN * kvec);
  endfor

  lo = m' + s'*2;
  hi = m' - s'*2;

  score = 0;

  function [value] = penalty(a, b)
  %  value = (abs(a - b) * 1000)^2;
    value = abs(a-b);
  endfunction

  score += ((theta(1) - mu(1))/0.15)^2;
  score += ((theta(2) - mu(2))/10)^2;
  score += ((theta(3) - mu(3))/1)^2;
  score += ((theta(4) - mu(4))/0.3)^2;
  score += ((theta(5) - mu(5))/20)^2;


  score += penalty(x(1), 0.45);
  score += penalty(x(2), 0.93);
  score += penalty(x(3), 0.57);
  score += penalty(x(4), -0.35);
  score += penalty(x(5), -0.79);
  score += penalty(x(6), -0.54);
  score += penalty(hi(1), 0.87);
  score += penalty(hi(2), 1.25);
  score += penalty(hi(3), 0.92);
  score += penalty(hi(4), 0);
  score += penalty(hi(5), 0.05);
  score += penalty(hi(6), 0.79);
if 0
  if x(1) < sine(1)
    score *= 3;
  endif
  if sine(2) < x(2)
    score *= 2;
  endif
  if hi(3) < sine(3) || sine(3) < lo(3)
    score *= 3;
  endif
  if x(4) < sine(4)
    score *= 3;
  endif
  if x(5) < sine(5) || sine(5) < lo(5)
    score *= 3;
  endif
  if sine(6) < x(6)
    score *= 3;
  endif
endif

endfunction
