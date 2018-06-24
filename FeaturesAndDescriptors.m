function [f,d] = FeaturesAndDescriptors(img, thresholdFactor)

    [r, c, s] = KeyPoints(img, thresholdFactor, false);
    fc = [r, c, s, zeros(size(r,1),1)]';
    [f,d] = vl_sift(single(img),'frames',fc,'orientations') ;
    
end