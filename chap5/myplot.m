function myplot(X, T, Y, msg)
  hold on
  clc;

  ymin = min(T) - 0.1;
%  if ymin < -1
%    ymin = -1
%  endif
  ymax = max(T) + 0.1;
%  if ymax > 1
%    ymax = 1
%  endif
  axis([-1, 1, ymin, ymax]);

  scatter(X, T, 'b');
  plot(X, Y, 'r');
  text(-0.95, ymax-0.095, msg);
  hold off
end
