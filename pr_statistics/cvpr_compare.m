function dst=cvpr_compare(F1, F2)

% This function should compare F1 to F2 - i.e. compute the distance
% between the two descriptors

% For now it just returns a random number

% Compute the Euclidean distance between F1 and F2 which are 2 feature
% descriptors

% Subtract each element of feature F1 from feature F2
x = F1 - F2;

% Square these differences
x = x .^2;

% Sum up the square differences
x = sum(x);

% Take the square root
dst = sqrt(x);

return;
