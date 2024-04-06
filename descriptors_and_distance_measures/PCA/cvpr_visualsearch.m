% cvpr_visualsearch.m

% Close any open figures and clear the workspace.
close all;
clear all;

% Define paths for dataset and descriptor storage.
DATASET_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2';
DESCRIPTOR_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors';
PCA_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\pca1';

% Read all image files from the specified directory and store their filenames.
imageFiles = dir(fullfile(DATASET_FOLDER, 'Images', '*.bmp'));
ALLFILES = {imageFiles.name};

% Load PCA basis, mean descriptor, and PCA descriptors
load(fullfile(PCA_FOLDER, 'pca_basis.mat'));
load(fullfile(PCA_FOLDER, 'mean_descriptor.mat'));
load(fullfile(PCA_FOLDER, 'pca_descriptors.mat'));

% Compute the inverse covariance matrix for Mahalanobis distance
invCovMatrix = pinv(cov(pcaDescriptors));
% Randomly select an image to be used as the query image.
queryIdx = randi(size(pcaDescriptors, 1));
queryDescriptor = pcaDescriptors(queryIdx, :);
queryImageFileName = ALLFILES{queryIdx};

% Get the labels for the query image.  
query_labels = get_image_labels(queryImageFileName);
relevance = zeros(1, size(pcaDescriptors, 1));

% Calculate distances between query and all descriptors using Mahalanobis distance
distances = zeros(size(pcaDescriptors, 1), 1);
for i = 1:size(pcaDescriptors, 1)
    % Mahaolobis distance between query and current image
    %distances(i) = cvpr_compare(queryDescriptor, pcaDescriptors(i, :), 'Mahalanobis', invCovMatrix);

    % Euclidean Distance L2 norm
    %distances(i) = cvpr_compare(queryDescriptor, pcaDescriptors(i, :), 'L2');

    % L1 Norm
    %distances(i) = cvpr_compare(queryDescriptor, pcaDescriptors(i, :), 'L1');

    % Cosine Similarity
    distances(i) = cvpr_compare(queryDescriptor, pcaDescriptors(i, :), 'Cosine');

    % Check for relevance of current image using ground truth labels.
    current_labels = get_image_labels(ALLFILES{i});
    if ~isempty(intersect(query_labels, current_labels))
        relevance(i) = 1;
    else
        relevance(i) = 0;
    end
end

% Combine distances with indices and sort by distance
dst = [(1:length(distances))', distances];
dst = sortrows(dst, 2);

% Display the query image
fprintf('Query image: %s\n', queryImageFileName);
query_img = imread(fullfile(DATASET_FOLDER, 'Images', queryImageFileName));
figure;
imshow(query_img, []);
title('Query Image');

% Visualize the top similar images to the query.
SHOW = 15;  % Show top 15 images
dst = dst(1:SHOW, :);
outdisplay = [];

for i = 1:SHOW
    img = imread(fullfile(DATASET_FOLDER, 'Images', ALLFILES{dst(i, 1)}));
    img = img(1:2:end, 1:2:end, :);  % Reduce the resolution for visualization.
    img = img(1:81, :, :);  % Further crop for consistent visualization.
    outdisplay = [outdisplay img];
end

figure;
imshow(outdisplay, []);
title('Top-Ranked Retrieval Results');
axis off;

% Save variables for evaluation
save(fullfile(DESCRIPTOR_FOLDER, 'evaluation_data.mat'), 'relevance', 'dst', 'SHOW', 'ALLFILES');

function labels = get_image_labels(filename)
    % This function retrieves the labels for a given image filename.
    
    % Extract only the base name from the given filename.
    [~, base_filename, ~] = fileparts(filename);
    
    % Construct the path for the ground truth file.
    gt_filename = ['C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2\GroundTruth\', base_filename, '_GT.bmp'];
    
    if ~exist(gt_filename, 'file')
        error(['File not found: ', gt_filename]);
    end

    gt_img = imread(gt_filename);
    labels = unique(gt_img); % Extract unique labels.
    labels(labels == 0) = []; % Remove the label for the background class.
end
