  function F=extractRandom(img)
% This is the function responsible for computing an image descriptor from
% an image.
%F=rand(1,30);

% THE 3D MATRIX has the following properties
% [height, width, color channels]
% color channels: Red = 1, BLue = 3, Green = 2
red = img(:, :, 1);
red = reshape(red, 1, []);
average_red = mean(red);

green = img(:, :, 2);
green = reshape(green, 1, []);
average_green = mean(green);    

blue= img(:, :, 3);
blue = reshape(blue, 1, []);
average_blue = mean(blue);

F = [average_red, average_green, average_blue];

% Returns a row [rand rand .... rand] representing an image descriptor
% computed from image 'img'

% Note img is a normalised RGB image i.e. colours range [0,1] not [0,255].

return;