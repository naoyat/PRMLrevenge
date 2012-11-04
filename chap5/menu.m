function run(type)
  X = linspace(-1,1,50);

  eta = 0.05;
  epsilon = 1e-4;
  
  ymax = 1.0;
  ymin = 0.0;

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
      ymin = -1.0;
    case 3
      T = abs(X);
    case 4
      T = Heaviside(X);
    case 5
      T = (sin(X*3) + cos(X*7)) / 2;
      ymin = -1.0;
    case 6
      T = 4 * X .* X .* X - X;
      ymin = -1.0;
  endswitch

  expr = exprs(type,:);

  [W1, W2, iter] = nnlearn(1:50, T, eta, epsilon);

  Y = zeros(1,50);
  for j = 1:50
    Y(j) = nn(j, W1, W2);
  endfor

  close all ; clc
  msg = sprintf("%s; iteration# until E(x) < %g: %d", expr, epsilon, iter);
  myplot(X, T, Y, ymin, ymax, msg, iter);
end
