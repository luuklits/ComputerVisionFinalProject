clear all; clc
%load the vlfeat library to use the computer vision algorithms
run('~/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup')

%load images into variables
img1 = rgb2gray(imread(char('left.jpg')));
img2 = rgb2gray(imread(char('right.jpg')));

%set thresholdfactor for the cornerness for the harris corner point detector
thresholdFactor = 0.02;

[f1,d1] = FeaturesAndDescriptors(img1, thresholdFactor);
[f2,d2] = FeaturesAndDescriptors(img2, thresholdFactor);

[matches, scores] = vl_ubcmatch(d1, d2) ;
sprintf("Got %i matches", length(matches))
%plotMatches(f1, f2, matches, img1, img2, size(matches,2));

%calculate the fundamental matrix A
[A, BestMatches] = FundamentalMatrix(img1, img2, scores, matches, f1, f2, 20, false);

%execute the normalized eight point algorithm with RANSAC on A
[Fbest, BestInliers] = NormalizedEightPointRansac(A, 0.001);



