% cvpr_compare.m
function distance = cvpr_compare(F1_pca, F2_pca, invCovMatrix)
    % Compute the Mahalanobis distance
    difference = F1_pca - F2_pca;
    distance = sqrt(difference * invCovMatrix * difference');
end
