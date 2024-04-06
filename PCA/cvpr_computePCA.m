%% cvpr_computePCA.m

% Load the matrix of all descriptors
load('C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\pca1\all_descriptors.mat');

% Normalize by subtracting the mean
meanDescriptor = mean(all_descriptors, 1);
all_descriptors = bsxfun(@minus, all_descriptors, meanDescriptor);

% Compute the covariance matrix
covMatrix = cov(all_descriptors);

% Perform eigendecomposition
[eigVectors, eigValues] = eig(covMatrix);

% Sort eigenvalues and eigenvectors in descending order
[eigValuesSorted, idx] = sort(diag(eigValues), 'descend');
eigVectorsSorted = eigVectors(:, idx);

% Compute the explained variance for each principal component
explainedVariances = diag(eigValuesSorted) / sum(diag(eigValuesSorted));

% Compute the cumulative explained variance
cumulativeVariances = cumsum(explainedVariances);
disp(cumulativeVariances);

plot(cumulativeVariances);
xlabel('Number of components');
ylabel('Cumulative explained variance');
grid on;
% Find the number of components that explain at least 95% of the variance
numComponents = find(cumulativeVariances >= 0.95, 1);

% Check if numComponents is empty
if isempty(numComponents)
    numComponents = 50;
end

fprintf("Number of components %d\n", numComponents);
% Select the principal components based on the number found
pcaBasis = eigVectorsSorted(:, 1:numComponents);

% Project descriptors into the PCA space
pcaDescriptors = all_descriptors * pcaBasis;

% Save the PCA basis, the mean descriptor, and the PCA descriptors
save('C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\pca1\pca_basis.mat', 'pcaBasis');
save('C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\pca1\mean_descriptor.mat', 'meanDescriptor');
save('C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\pca1\pca_descriptors.mat', 'pcaDescriptors');
