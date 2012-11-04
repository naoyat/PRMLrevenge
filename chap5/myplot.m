function myplot(X, T, Y, msgs)
  hold on
  clc;

  ymin = min(T) - 0.1;
  ymax = max(T) + 0.1;
  axis([-1, 1, ymin, ymax]);

  scatter(X, T, 'b');
  plot(X, Y, 'r');
  text(-0.95, ymax-0.065, msgs(1,:));
  text(-0.95, ymax-0.105, msgs(2,:));
  hold off
end
