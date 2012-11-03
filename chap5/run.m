function run(type)
  J = linspace(1,50,50);
  X = linspace(-1,1,50);

  eta = 0.05;
  epsilon = 1e-4;
  
  ymax = 1.0;
  ymin = 0.0;
  expr = "";

  if type == 1
    expr = "y = x^2";
    T = X .* X;
  elseif type == 2
    expr = "y = sin(2x)";
    T = sin(X*2);
    ymin = -1.0;
  elseif type == 3
    expr = "y = |x|";
    T = abs(X);
  elseif type == 4
    expr = "y = Heaviside(x)";
    T = Heaviside(X);
  elseif type == 5
    expr = "y = sin(3x) + cos(7x)";
    T = (sin(X*3) + cos(X*7)) / 2;
    ymin = -1.0;
  elseif type == 6
    expr = "y = 4x^3 - x";
    T = 4 * X .* X .* X - X;
    ymin = -1.0;
  end

  [W1, W2, iter] = nnlearn(J, T, eta, epsilon);

  Y = zeros(1,50);
  for j = 1:50
    Y(j) = nn(j, W1, W2);
  end

  close all ; clc
  msg = sprintf("%s; iteration# until E(x) < %g: %d", expr, epsilon, iter);
  myplot(X, T, Y, ymin, ymax, msg, iter);
end
