function [Fbest, BestInliers, x1inliers, y1inliers, x2inliers, y2inliers] = NormalizedEightPointRansac(A, matches,f1, f2, threshold)
    %normalization of the data
    index1 = matches(1,:);
    index2 = matches(2,:);
    x1 =  f1(1,index1)
    y1 =  f1(2,index1)
    x2 =  f2(1,index2)
    y2 =  f2(2,index2)
    [T1, phat1] = Normalization(x1, y1);
    [T2, phat2] = Normalization(x2, y2);
    sprintf("Normalized the Fundamental Matrix")
    
    % RANSAC
    [Fbest, BestInliers] = RANSAC(phat1, phat2, threshold);
    sprintf("Executed the Eight-Point Algorithm with Ransac on the normalized Data")
    sprintf("Got %i inliers from the best transformation", length(BestInliers))
    
    InliersIndices1 = matches(1,BestInliers);
    InliersIndices2 = matches(2,BestInliers);
    x1inliers = f1(1,InliersIndices1);
    y1inliers = f1(2,InliersIndices1);
    x2inliers = f2(1,InliersIndices2);
    y2inliers = f2(2,InliersIndices2);
    
end