function d = cvpr_compare(F1, F2, method, invCovMatrix)
    % Check number of input arguments and set default method
    if nargin < 3
        method = 'L2'; % Default to L2 if no method is specified
    end
    
    % Calculate the distance based on the specified method
    switch method
        case 'L2'
            d = sqrt(sum((F1 - F2) .^ 2));
        case 'L1'
            d = sum(abs(F1 - F2));
        case 'Mahalanobis'
            if nargin < 4
                error('Inverse covariance matrix is required for Mahalanobis distance');
            end
            difference = F1 - F2;
            d = sqrt(difference * invCovMatrix * difference');
        case 'Cosine'
            d = 1 - dot(F1, F2) / (norm(F1) * norm(F2));
        % Add more cases for other distance measures if needed
        otherwise
            error('Unknown method: %s', method);
    end
end
