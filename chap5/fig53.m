function fig53(type)
  X = linspace(-1,1,50)';

  % 学習率
  eta = 0.05;

  % 学習打ち切り閾値
  epsilon = 1e-4;
  
  exprs = ['y = x^2'
           'y = sin(2x)'
           'y = |x|'
           'y = Heaviside(x)'
           'y = sin(3x) + cos(7x)'
           'y = 4x^3 - x'
           ];
     
  type = menu('type', exprs(1,:), exprs(2,:), exprs(3,:), exprs(4,:), exprs(5,:), exprs(6,:));
  switch type
    case 1
      T = X .* X;
    case 2
      T = sin(X*2);
    case 3
      T = abs(X);
    case 4
      T = (X > 0)*1; % Heaviside(X);
    case 5
      T = (sin(X*3) + cos(X*7)) / 2;
    case 6
      T = 4 * X .* X .* X - X;
  endswitch

  expr = exprs(type,:);

  I = eye(50);
  [W1, W2, iter] = nnlearn(I, T, eta, epsilon);

  Y = zeros(50,1);
  for j = 1:50
    IN = zeros(50,1);
    IN(j) = 1;
    Y(j) = nn(IN, W1, W2);
  endfor

  close all ; clc
  msg = sprintf("%s; iteration# until E(x) < %g: %d", expr, epsilon, iter);
  myplot(X, T, Y, msg, iter);
end
