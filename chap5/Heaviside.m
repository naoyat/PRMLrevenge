function [S] = Heavyside(X)

% M = numel(X);
% S = zeros(1,M);
% 
% for j = 1:M
%   if (X(j) > 0)
%     S(j) = 1;
%   else
%     S(j) = 0;
%   end
% end

S = X > 0;

end
