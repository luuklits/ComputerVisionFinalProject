function F = gaussianDerivates(img, sigma, type)
%This Function can convolve images with a derivative kernel to obtain the
%derivative in various directions, e.g x, x^2, y, y^2, xy
    n = floor(3*sigma+0.5);
    % first define the normal distribution for the Gaussian Derivative
    % then calculate the Gaussian of the image and apply
    % and then define the Gaussian Derivative Filter
    x = linspace(-3*sigma, 3*sigma, (2*n + 1));
    G = (1/(sigma*sqrt(2*pi))) * exp(-x.^2/(2*sigma^2));
    G = G/sum(G);
    Gd = - x ./ sigma.^2 .* G;
    
    % Check whether the image is a RGB or grayscale
    % If it is RGB convert it to a grayscale image
    if length(size(img)) == 3
        img = rgb2gray(img);
    end
    
    % Now loop through the type inserted to seet the convolution structure
    % E.g. xy would mean convolve once with the Gd along x and once along y
    Der = img;
    for i = type
        if i == 'x'
            Der = conv2(Der,Gd,'same');
        end
        
        if i =='y'
            Der = conv2(Der,transpose(Gd),'same');
        end
    end
    
    % Return the convolved derivative image
    F = Der;
end


