function [Y] = nn(J, W1, W2)
  D = size(W1);

  X = zeros(D(2),1);
  X(J) = 1;

  A = W1 * X;
  Z = tanh(A);

  Y = W2 * [1; Z];
end
