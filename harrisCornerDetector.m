function [r, c, R] = harrisCornerDetector(img, sigma, thresholdFactor)
% inputs: 
% im: double grayscale image
% sigma: integration-scale
% outputs:  The row and column of each point is returned in r and c
% This function finds Harris corners at integration-scale sigma.
% The derivative-scale is chosen automatically as gamma*sigma
n = floor(3*sigma+0.5);

gamma = 0.7; % The derivative-scale is gamma times the integration scale

% Calculate Gaussian Derivatives at derivative-scale
% Hint: use your previously implemented function in assignment 1 
Ix =  gaussianDerivates(img, sigma, 'x');
Iy =  gaussianDerivates(img, sigma, 'y');

% Allocate an 3-channel image to hold the 3 parameters for each pixel
M = zeros(size(Ix,1), size(Ix,2), 3);

% Calculate M for each pixel
M(:,:,1) = Ix.^2;
M(:,:,2) = Iy.^2;
M(:,:,3) = Ix.*Iy;

% Smooth M with a gaussian at the integration scale ...sigma.
M = imfilter(M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');

% Compute the cornerness R
trace = Ix.^2 .* Iy.^2;
det = (Ix.^2 .* Iy.^2) - (2*Ix.*Iy);
R = det - 0.05*(trace).^2;

% Set the threshold 
threshold = thresholdFactor*max(max(R));

% Find local maxima
% Dilation will alter every pixel except local maxima in a 3x3 square area.
% Also checks if R is above threshold
thresholdR = ((R>threshold) & ((imdilate(R, strel('square', 3))==R)));

% Display corners
%figure
%imshow(thresholdR,[]);

% Return the coordinates
[r,c] = find(thresholdR(2:end-1,2:end-1)>threshold);
r = r + 1;
c = c + 1;




ind = sub2ind(size(R),r,c);
R = R(ind);
R = R';
end
