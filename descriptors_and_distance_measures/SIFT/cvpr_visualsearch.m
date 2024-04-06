% cvpr_visualsearch.m

% Close any open figures and clear the workspace.
close all;
clear all;

% Define paths for dataset and descriptor storage.
DATASET_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2';
DESCRIPTOR_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\SIFT1';

% Read all image files from the specified directory aGnd store their filenames.
imageFiles = dir(fullfile(DATASET_FOLDER, 'Images', '*.bmp'));
ALLFILES = {imageFiles.name};

% Initialize the cell array to store the descriptors
allDescriptors = cell(length(ALLFILES), 1);

% Load all SIFT descriptors
for i = 1:length(ALLFILES)
    fname = ALLFILES{i};
    matFilename = fullfile(DESCRIPTOR_FOLDER, [fname(1:end-4), '_SIFT.mat']);
    if exist(matFilename, 'file')
        temp = load(matFilename);
        allDescriptors{i} = temp.features; % 'features' should be a matrix or cell array of descriptors
    else
        error(['SIFT descriptor file not found for image: ', fname]);
    end
end

% Randomly select an image to be used as the query image.
queryIdx = randi(length(ALLFILES));
queryImageFileName = ALLFILES{queryIdx};
matFilename = fullfile(DESCRIPTOR_FOLDER, [queryImageFileName(1:end-4), '_SIFT.mat']);
queryData = load(matFilename);

% Select the first descriptor (or use an average) for the query image
queryDescriptor = queryData.features(1, :); % Using the first descriptor as an example

% Initialize distances with infinity
distances = inf(length(allDescriptors), 1);

% Loop over each set of descriptors for each image
for i = 1:length(allDescriptors)
    currentFeatures = allDescriptors{i}; % Get the features for the current image
    minDistanceForImage = inf; % Initialize minimum distance for this image

    % Loop over each descriptor in the current image
    for j = 1:size(currentFeatures, 1)
        currentDescriptor = currentFeatures(j, :);
        if isvector(currentDescriptor)
            currentDistance = cvpr_compare(queryDescriptor, currentDescriptor, 'L2');
            minDistanceForImage = min(minDistanceForImage, currentDistance);
        else
            error('One of the descriptors is not a vector.');
        end
    end

    % Store the minimum distance found for this image
    distances(i) = minDistanceForImage;
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
    imgIdx = dst(i, 1);
    img = imread(fullfile(DATASET_FOLDER, 'Images', ALLFILES{imgIdx}));
    img = img(1:2:end, 1:2:end, :);  % Reduce the resolution for visualization.
    img = img(1:81, :, :);  % Further crop for consistent visualization.
    outdisplay = [outdisplay img];
end

figure;
imshow(outdisplay, []);
title('Top-Ranked Retrieval Results');
axis off;

% Save variables for evaluation
save(fullfile(DESCRIPTOR_FOLDER, 'evaluation_data.mat'), 'dst', 'SHOW', 'ALLFILES');

function labels = get_image_labels(filename)
    % This function retrieves the labels for a given image filename.
    [~, base_filename, ~] = fileparts(filename);
    gt_filename = fullfile(DATASET_FOLDER, 'GroundTruth', [base_filename, '_GT.bmp']);
    if ~exist(gt_filename, 'file')
        error(['File not found: ', gt_filename]);
    end
    gt_img = imread(gt_filename);
    labels = unique(gt_img);
    labels(labels == 0) = []; % Remove the label for the background class.
end
