%extractRGB_histogram
function F=extractRGB_histogram(img)
    % Extracts a normalized RGB histogram descriptor from the given image.
    % This function uses quantized RGB values for histogram computation.
    
    % Level of quantization of the RGB space. Adjust this value as needed.
    Q = 2; % 2, 4(DEFAULT), 8, 16 
    
    % Normalize and quantize the RGB values.
    %qimg = double(img) ./ 256; remove because we normalize in compute
    %desriptors so trying to avoid double normalization
    qimg = double(img); 
    qimg = floor(qimg * Q);
    
    % Convert the 3D RGB values into a single value for histogram binning.
    bin = qimg(:,:,1) * Q^2 + qimg(:,:,2) * Q + qimg(:,:,3);
    
    % Reshape the 2D binning data into a 1D vector.
    vals = reshape(bin, 1, size(bin, 1)*size(bin,2));
    
    % Compute the histogram.
    H = histcounts(vals, 0:Q^3);
    
    % Normalize the histogram.
    F = H ./ sum(H);
    
end
