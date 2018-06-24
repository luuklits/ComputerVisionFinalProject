function L = laPlacian(sigma, img)
    L = sigma^2 * (gaussianDerivates(img, sigma, 'xx') + gaussianDerivates(img, sigma, 'yy'));
end