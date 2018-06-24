clear all; clc
%load the vlfeat library to use the computer vision algorithms
run('~/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup')

%load images into variables
imagepaths = [  char('TeddyBearAdj/obj02_001.jpg'), char('TeddyBearAdj/obj02_002.jpg'), char('TeddyBearAdj/obj02_003.jpg'), ...
                char('TeddyBearAdj/obj02_004.jpg'), char('TeddyBearAdj/obj02_005.jpg'), char('TeddyBearAdj/obj02_006.jpg'), ...
                char('TeddyBearAdj/obj02_007.jpg'), char('TeddyBearAdj/obj02_008.jpg'), char('TeddyBearAdj/obj02_009.jpg'), ...
                char('TeddyBearAdj/obj02_010.jpg'), char('TeddyBearAdj/obj02_011.jpg'), char('TeddyBearAdj/obj02_012.jpg'), ...
                char('TeddyBearAdj/obj02_013.jpg'), char('TeddyBearAdj/obj02_014.jpg'), char('TeddyBearAdj/obj02_015.jpg'), ...
                char('TeddyBearAdj/obj02_016.jpg'), char('TeddyBearAdj/obj02_017.jpg'), char('TeddyBearAdj/obj02_018.jpg'), ...
                char('TeddyBearAdj/obj02_019.jpg'), char('TeddyBearAdj/obj02_020.jpg')]
    
img1 = rgb2gray(imread(char('TeddyBearAdj/obj02_001.jpg')));
img2 = rgb2gray(imread(char('TeddyBearAdj/obj02_002.jpg')));
img3 = rgb2gray(imread(char('TeddyBearAdj/obj02_003.jpg')));
img4 = rgb2gray(imread(char('TeddyBearAdj/obj02_004.jpg')));
img5 = rgb2gray(imread(char('TeddyBearAdj/obj02_005.jpg')));
img6 = rgb2gray(imread(char('TeddyBearAdj/obj02_006.jpg')));
img7 = rgb2gray(imread(char('TeddyBearAdj/obj02_007.jpg')));
img8 = rgb2gray(imread(char('TeddyBearAdj/obj02_008.jpg')));
img9 = rgb2gray(imread(char('TeddyBearAdj/obj02_009.jpg')));
img10 = rgb2gray(imread(char('TeddyBearAdj/obj02_010.jpg')));
img11 = rgb2gray(imread(char('TeddyBearAdj/obj02_011.jpg')));
img12 = rgb2gray(imread(char('TeddyBearAdj/obj02_012.jpg')));
img13 = rgb2gray(imread(char('TeddyBearAdj/obj02_013.jpg')));
img14 = rgb2gray(imread(char('TeddyBearAdj/obj02_014.jpg')));
img15 = rgb2gray(imread(char('TeddyBearAdj/obj02_015.jpg')));
img16 = rgb2gray(imread(char('TeddyBearAdj/obj02_016.jpg')));
img17 = rgb2gray(imread(char('TeddyBearAdj/obj02_017.jpg')));
img18 = rgb2gray(imread(char('TeddyBearAdj/obj02_018.jpg')));
img19 = rgb2gray(imread(char('TeddyBearAdj/obj02_019.jpg')));
img20 = rgb2gray(imread(char('TeddyBearAdj/obj02_020.jpg')));

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



