function [features, validPoints] = SIFTdescriptor(img)
    % This function extracts SIFT features from the input image and returns them.

    % Ensure the image is in grayscale
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Detect SIFT keypoints in the image
    keypoints = detectSIFTFeatures(img);
    
    % Extract features at the keypoints. Note that features here are the SIFT
    % descriptors and validPoints are the actual locations of these keypoints.
    [features, validPoints] = extractFeatures(img, keypoints);
    
    % Optionally, you can visualize the keypoints
    % imshow(img); hold on;
    % plot(validPoints.selectStrongest(10), 'showOrientation', true);
end
