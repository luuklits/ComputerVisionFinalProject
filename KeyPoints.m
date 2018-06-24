function [r, c, s] = KeyPoints(img, thresholdFactor,PLOT)
    %create a list x, containing the different values for sigma to loop through
    x = -9:1:12;
    x = 1.2.^x;

    %Create corner point matric CP & Laplacian matrix LP for all sigmas
    CP = zeros(size(img,1),size(img,2),length(x));
    LP = zeros(size(img,1),size(img,2),length(x));

    i = 0;
    for sigma=x
        i = i+1;
        [r, c, R] = harrisCornerDetector(img, sigma, thresholdFactor);
        L = laPlacian(sigma, img);
        indices1 = sub2ind(size(LP(:,:,i)),r,c);

        LPi = LP(:,:,i);
        LPi(indices1) = L(indices1);
        LP(:,:,i) = LPi;

    end

    [r, c, s] = ind2sub(size(LP),find((imdilate(LP,strel('cuboid', [3 22 22])) == LP) & (LP~=0)));
    s = 1.2.^(s-10);
    s = s*2 + 1.0;
    
    sprintf("number of keypoint found in image: %i", size(r,1))
    if PLOT
        figure;
        imshow(img);
        hold on;
        plot(c,r,'x');
    end

end