function myplot(X, T, Y, msg)
  hold on
  clc;
  ymin = min(Y) - 0.1;
  ymax = max(Y) + 0.1;
  axis([-1, 1, ymin, ymax]);
  scatter(X, T, 'b');
  plot(X, Y, 'r');
  text(-0.95, ymax-0.095, msg);
  hold off
end
