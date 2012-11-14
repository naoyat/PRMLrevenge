function [product] = outer(a, b, fn)
  %
  % 第3引数に関数を取るouter()をとりあえず用意
  %

  R = length(a);
  C = length(b);

  product = zeros(R, C);

  for r = 1:R
    for c = 1:C
      product(r,c) = fn(a(:,r), b(:,c));
    endfor
  endfor

endfunction
