function [W1, W2, iter] = nnlearn(Xs, Ts, Eta, Epsilon)
  % 入力ベクタのサイズ
  M = rows(Xs);

  % データ数
  N = columns(Xs);

  W1 = rand(3, M+1)/10;  % 3x(M+1)
  W2 = rand(1, 3+1)/10;  % kx(3+1)

  for i = 1:500
    DTotal = 0;
    for j = 1:N
      X = Xs(:,j);  % Mx1
      A = W1 * [1; X];  % 3x(M+1) * (M+1)x1 = 3x1
      Z = tanh(A);  % 3x1
      Y = W2 * [1; Z];  % kx(3+1) * (3+1)x1 = kx1

      D2 = Y - Ts(j,:);  % kx1
      En = (D2' * D2)/2;
      DTotal += En;

      W2 -= Eta * (D2 * [1;Z]');  % kx1 * 1x(3+1) = kx(3+1)

      R = 1 - (Z' * Z);
      D1 = R * (W2' * D2);  % (3+1)xk * kx1 = (3+1)x1 -> 3*1
      W1 -= Eta * (D1(2:4) * [1;X]');  % 3x1 * 1x(M+1) = 3x(M+1)
    endfor

    % 誤差の合計がεを下回るようになったら終了
    if DTotal < Epsilon
      break;
    end
  endfor
  iter = i;
end
