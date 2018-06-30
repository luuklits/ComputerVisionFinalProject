function [Fbest, BestInliers] = RANSAC(phat1, phat2, threshold)
    NrBestInliers = 0;
    N = 20000;
    for n = 1:N
        perm = randperm(length(phat1));
        selec = perm(1:8);
        phat1selec = phat1(:, selec);
        phat2selec = phat2(:, selec);

        Ar = [];
        for i = 1:1:length(phat1selec)
            xi1 = phat1selec(1,i);
            yi1 = phat1selec(2,i);
            xi2 = phat2selec(1,i);
            yi2 = phat2selec(2,i);
            Ar(i,:) = [xi1*xi2 xi1*yi2 xi1 yi1*xi2 yi1*yi2 yi1 xi2 yi2 1];
        end

        [V, ~]   = eigs(Ar' * Ar, 1, 'smallestabs');
        f_ransac = V;
        Fr = reshape(f_ransac, 3, 3);

        Fp = Fr * phat1;
        Fpt= Fr'* phat1;
        d   = zeros(1, length(phat1));

        for i = 1:length(phat1)
            d(i) = (phat2(:,i)' * Fr * phat1(:,i))^2 / (Fp(1,i)^2 + Fp(2,i)^2 + Fpt(1,i)^2 + Fpt(2,i)^2);
        end

        inliers     = find(d < threshold);
        NrInliers   = length(inliers);

        if NrInliers > NrBestInliers   
            NrBestInliers   = NrInliers;
            BestInliers    = inliers;
            Fbest          = Fr;  
        end
    end
    
    
end