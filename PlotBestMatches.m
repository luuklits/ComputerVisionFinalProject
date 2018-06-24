function PlotBestMatches(img1,img2,r1,c1,r2,c2)
    figure;
    imshowpair(img1,img2,'montage');
    hold on;
    plot(r1, c1,'o');
    hold on;
    plot(r2+size(img1,2), c2,'o');
    for i = 1:1:size(r1,2)
        hold on;
        line([r1(i) r2(i)+size(img1,2)],[c1(i),c2(i)]);
end