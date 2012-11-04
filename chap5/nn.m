function [Y] = nn(X, W1, W2)
  A = W1 * [1; X];
  Z = tanh(A);

  Y = W2 * [1; Z];
end
