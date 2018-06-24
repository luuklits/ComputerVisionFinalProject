function [T, phat] = Normalization(x, y)
    mx = mean(x);
    my = mean(y);
    d = sum(sqrt((x-mx).^2 + (y-my).^2))/length(x);
    T = [sqrt(2)/d  0           -mx*sqrt(2)/d;
         0          sqrt(2)/d   -my*sqrt(2)/d;
         0          0           1];
    p = [x y ones(length(x),1)]';
    phat = T*p;
end