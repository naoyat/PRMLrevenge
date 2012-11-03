function myplot(X, T, Y, ymin, ymax, msg)
  hold on
  clc;
  axis([-1, 1, ymin-0.1, ymax+0.1]);
  scatter(X, T, 'b');
  plot(X, Y, 'r');
  text(-0.95, 1.02, msg);
  hold off
end
