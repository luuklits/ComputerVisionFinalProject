clear all; clc
%load the vlfeat library to use the computer vision algorithms
run('~/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup')

%load images into variables
imagepaths = [  [char('model_castle_adj/8ADT8586.JPG')]; [char('model_castle_adj/8ADT8587.JPG')]; [char('model_castle_adj/8ADT8588.JPG')]; ...
                [char('model_castle_adj/8ADT8589.JPG')]; [char('model_castle_adj/8ADT8590.JPG')]; [char('model_castle_adj/8ADT8591.JPG')]; ...
                [char('model_castle_adj/8ADT8592.JPG')]; [char('model_castle_adj/8ADT8593.JPG')]; [char('model_castle_adj/8ADT8594.JPG')]; ...
                [char('model_castle_adj/8ADT8595.JPG')]; [char('model_castle_adj/8ADT8596.JPG')]; [char('model_castle_adj/8ADT8597.JPG')]; ...
                [char('model_castle_adj/8ADT8598.JPG')]; [char('model_castle_adj/8ADT8599.JPG')]; [char('model_castle_adj/8ADT8600.JPG')]; ...
                [char('model_castle_adj/8ADT8601.JPG')]; [char('model_castle_adj/8ADT8602.JPG')]; [char('model_castle_adj/8ADT8603.JPG')]; ...
                [char('model_castle_adj/8ADT8604.JPG')]; [char('model_castle_adj/8ADT8586.JPG')];];
            

    
PointViewMatrix = [];
LocationsMatrix = [];
IAMatrix = [];
for i = 1:1:(size(imagepaths,1)-1)
    img1 = rgb2gray(imread(imagepaths(i,:)));
    img2 = rgb2gray(imread(imagepaths(i+1,:)));
    %set thresholdfactor for the cornerness for the harris corner point detector
    thresholdFactor = 0.2;

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
        sprintf("size IA: %i", length(IA))
        IAMatrix = [IAMatrix, length(IA)]
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

save("PointViewMatrixCastle02.mat","PointViewMatrix")
save("LocationsMatrixXCastle02.mat", "LocationsMatrixX")
save("LocationsMatrixYCastle02.mat", "LocationsMatrixY")


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
















