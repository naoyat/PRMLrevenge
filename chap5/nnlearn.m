function [W1, W2, iter] = nnlearn(J, T, Eta, Epsilon)
  M = numel(J);
  W1 = rand(3, M+1)/10;
  W2 = rand(1, 3+1)/10;

  for i = 1:2000
    DTotal = 0;
    for j = 1:M
      X = zeros(M, 1);
      X(j) = 1;
      A = W1 * [1;X];
      Z = tanh(A);
      Y = W2 * [1;Z];
      D2 = Y - T(j);
      DTotal += D2*D2;

      W2 -= Eta * (D2 * [1;Z]');

      R = 1 - (Z' * Z);
      D1 = R * (W2' * D2); % 4 1
      W1 -= Eta * (D1(2:4) * [1;X]');
    end
    if DTotal < Epsilon
      break;
    end
  end
  iter = i;
end
