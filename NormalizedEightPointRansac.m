function [Fbest, BestInliers] = NormalizedEightPointRansac(A, threshold)
    %normalization of the data
    x1 =  A(:,3);
    y1 =  A(:,6);
    x2 =  A(:,7);
    y2 =  A(:,8);
    [T1, phat1] = Normalization(x1, y1);
    [T2, phat2] = Normalization(x2, y2);
    sprintf("Normalized the Fundamental Matrix")
    
    % RANSAC
    [Fbest, BestInliers] = RANSAC(phat1, phat2, threshold);
    sprintf("Executed the Eight-Point Algorithm with Ransac on the normalized Data")
    sprintf("Got %i inliers from the best transformation", length(BestInliers))
end