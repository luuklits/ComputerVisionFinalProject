function [A, BestMatches, FA] = FundamentalMatrix(img1, img2, scores, matches, f1, f2, n, PLOT)
    MatchesMatrix = [scores; matches];
    [elements, indices] = sort(MatchesMatrix(1,:));
    MatchesMatrix = MatchesMatrix(:,indices);

    BestMatches = MatchesMatrix(:,1:20);
    r1 = f1(1,BestMatches(2,:));
    c1 = f1(2,BestMatches(2,:));
    r2 = f2(1,BestMatches(3,:));
    c2 = f2(2,BestMatches(3,:));
    if PLOT
        PlotBestMatches(img1,img2,r1,c1,r2,c2);
    end

    A = [];
    for i = 1:1:length(r1)
        xi1 = r1(i);
        yi1 = c1(i);
        xi2 = r2(i);
        yi2 = c2(i);
        A(i,:) = [xi1*xi2 xi1*yi2 xi1 yi1*xi2 yi1*yi2 yi1 xi2 yi2 1];
    end
    sprintf("Fundamental Matrix Calculated")
    
end