function plotMatches(f1, f2, matches, img1, img2, np)
    np = randperm(np);

    rows1 = f1(1,[matches(1,np)]);
    columns1 = f1(2,[matches(1,np)]);
    rows2 = f2(1,[matches(2,np)]) + size(img1,2);
    columns2 = f2(2,[matches(2,np)]);

    figure
    imshowpair(img1,img2,'montage');

    for i = 1:1:size(columns1,2)
        x1 = rows1(i);
        x2 = rows2(i);
        y1 = columns1(i);
        y2 = columns2(i);
        hold on
        line([x1,x2],[y1,y2]);
        hold on
        plot(x1, y1, 'x');
        hold on
        plot(x2, y2, 'x');
    end
end