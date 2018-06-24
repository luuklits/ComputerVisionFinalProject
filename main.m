clear all; clc
%load the vlfeat library to use the computer vision algorithms
run('~/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup')

%load images into variables
img1 = rgb2gray(imread(char('model_castle/8ADT8586.JPG')));
img2 = rgb2gray(imread(char('model_castle/8ADT8587.JPG')));

%set thresholdfactor for the cornerness for the harris corner point detector
thresholdFactor = 0.95;

[f1,d1] = FeaturesAndDescriptors(img1, thresholdFactor);
[f2,d2] = FeaturesAndDescriptors(img2, thresholdFactor);

[matches, scores] = vl_ubcmatch(d1, d2) ;
sprintf("Got %i matches", length(matches))
%plotMatches(f1, f2, matches, img1, img2, size(matches,2));

%calculate the fundamental matrix A
[A, BestMatches] = FundamentalMatrix(img1, img2, scores, matches, f1, f2, 20, false);

%execute the normalized eight point algorithm with RANSAC on A
[Fbest, BestInliers, x1inliers, y1inliers, x2inliers, y2inliers] = NormalizedEightPointRansac(A, matches, f1, f2, 0.001);

figure
imshowpair(img1,img2,'montage');

for i = 1:1:length(x1inliers)
    x1 = x1inliers(i);
    x2 = x2inliers(i) + size(img1,2);
    y1 = y1inliers(i);
    y2 = y2inliers(i);
    hold on
    line([x1,x2],[y1,y2]);
    hold on
    plot(x1, y1, 'x');
    hold on
    plot(x2, y2, 'x');
end



