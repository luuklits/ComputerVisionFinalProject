clear all; clc
%load the vlfeat library to use the computer vision algorithms
run('~/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup')

%load images into variables
imagepaths = [  [char('TeddyBearAdj/obj02_001.jpg')]; [char('TeddyBearAdj/obj02_002.jpg')]; [char('TeddyBearAdj/obj02_003.jpg')]; ...
                [char('TeddyBearAdj/obj02_004.jpg')]; [char('TeddyBearAdj/obj02_005.jpg')]; [char('TeddyBearAdj/obj02_006.jpg')]; ...
                [char('TeddyBearAdj/obj02_007.jpg')]; [char('TeddyBearAdj/obj02_008.jpg')]; [char('TeddyBearAdj/obj02_009.jpg')]; ...
                [char('TeddyBearAdj/obj02_010.jpg')]; [char('TeddyBearAdj/obj02_011.jpg')]; [char('TeddyBearAdj/obj02_012.jpg')]; ...
                [char('TeddyBearAdj/obj02_013.jpg')]; [char('TeddyBearAdj/obj02_014.jpg')]; [char('TeddyBearAdj/obj02_015.jpg')]; ...
                [char('TeddyBearAdj/obj02_016.jpg')]; [char('TeddyBearAdj/obj02_017.jpg')]; [char('TeddyBearAdj/obj02_018.jpg')]; ...
                [char('TeddyBearAdj/obj02_019.jpg')]; [char('TeddyBearAdj/obj02_020.jpg')]];
    
PointViewMatrix = [];
LocationsMatrix = [];
for i = 1:1:(size(imagepaths,1)-1)
    img1 = rgb2gray(imread(imagepaths(i,:)));
    img2 = rgb2gray(imread(imagepaths(i+1,:)));
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
    [Fbest, BestInliers, x1inliers, y1inliers, x2inliers, y2inliers] = NormalizedEightPointRansac(A, matches, f1, f2, 0.001);
    
    if i == 1
        PointViewMatrix = matches(:,BestInliers);
        LocationsMatrixX = [x1inliers;x2inliers];
        LocationsMatrixY = [y1inliers;y2inliers];
        prev = PointViewMatrix(end,:);
    else
        PointViewMatrix(i+1,:) = zeros(1,size(PointViewMatrix,2));
        inliermatches = matches(:,BestInliers);
        new = inliermatches(1,:);
        [~, IA, IB] = intersect(new(1,:), prev(1,:));
        PointViewMatrix(i+1,IB) = inliermatches(2,IA);
        LocationsMatrixX(i+1,IB) = x2inliers(IA);
        LocationsMatrixY(i+1,IB) = y2inliers(IA);
        inliermatches(:,IA) = [];
        xinliers = [x1inliers; x2inliers];
        yinliers = [y1inliers; y2inliers];
        xinliers(:,IA) = [];
        yinliers(:,IA) = [];
        extension = zeros(size(PointViewMatrix,1),size(inliermatches,2));
        PointViewMatrix = [PointViewMatrix, extension];
        LocationsMatrixX = [LocationsMatrixX, extension];
        LocationsMatrixY = [LocationsMatrixY, extension];
        PointViewMatrix(end-1:end,(size(PointViewMatrix,2)-size(inliermatches,2))+1:end) = inliermatches;
        LocationsMatrixX(end-1:end,(size(PointViewMatrix,2)-size(inliermatches,2))+1:end) = xinliers;
        LocationsMatrixY(end-1:end,(size(PointViewMatrix,2)-size(inliermatches,2))+1:end) = yinliers;
        prev = PointViewMatrix(end,:);
        
    end
end


n_cons_imgs = 3;
pvm_mat = PointViewMatrix;
n_views = size(pvm_mat,1);
in = pvm_mat > 0;
for i = 1:n_views
    %make sure the indices roll over propperly
    rows = 1+mod(i:(i+n_cons_imgs-1),n_views);
    
    %find measurement indices which occur in the amount of
    %consecuitive images specified
    meas_in = sum(in(rows,:))>(n_cons_imgs-1);
    rows
    sum(meas_in)
    %retrieve actual indices
    match_ind = pvm_mat(rows,meas_in);
    
end

















