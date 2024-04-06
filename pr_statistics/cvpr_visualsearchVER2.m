% cvpr_visualsearch.m

% Close any open figures and clear the workspace.
close all;
clear all;

% Define paths for dataset and descriptor storage.
DESCRIPTOR_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors';
DESCRIPTOR_SUBFOLDER = 'globalRGBhisto';

% Load image descriptors from storage.
ALLFEAT = [];
ALLFILES = cell(1,0);
ctr = 1;

% Read all image files from the specified directory.
allfiles = dir('C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2\Images\*.bmp'); 

% Loop over each image file.
for filenum=1:length(allfiles)
    fname = allfiles(filenum).name;
    imgfname_full = ['C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2\Images\', fname];
    img = double(imread(imgfname_full))./255;

    % Load corresponding feature descriptor file.
    featfile = fullfile(DESCRIPTOR_FOLDER, DESCRIPTOR_SUBFOLDER, [fname(1:end-4), '.mat']);
    load(featfile, 'F');
    
    ALLFILES{ctr} = imgfname_full;
    ALLFEAT = [ALLFEAT ; F];
    ctr = ctr + 1;
end

% Randomly select an image to be used as the query image.
NIMG = size(ALLFEAT,1);
queryimg = floor(rand()*NIMG) + 1;
queryimg_filename = ALLFILES{queryimg};

% Obtain ground truth labels for the query image.
query_labels = get_image_labels(queryimg_filename);
relevance = zeros(1, NIMG);

dst = [];
% Loop over each image to compute the distance to the query image.
for i=1:NIMG
    candidate = ALLFEAT(i,:);
    query = ALLFEAT(queryimg,:);
    thedst = cvpr_compare(query, candidate);
    
    % Check for relevance of current image using ground truth labels.
    current_labels = get_image_labels(ALLFILES{i});
    if ~isempty(intersect(query_labels, current_labels))
        relevance(i) = 1;
    end
    
    dst = [dst ; [thedst i]];
end

% Sort images based on the computed distance.
dst = sortrows(dst, 1);

% Visualize the top similar images to the query.
SHOW = 15;
dst = dst(1:SHOW,:);
outdisplay = [];
for i=1:size(dst,1)
    img = imread(ALLFILES{dst(i,2)});
    img = img(1:2:end, 1:2:end, :); % Reduce the resolution for visualization.
    img = img(1:81, :, :); % Further crop for consistent visualization.
    outdisplay = [outdisplay img];
end

imgshow(outdisplay); % Display the visual results.
axis off;

% Initialize Arrays for precision and recall.
precision_array = zeros(1, SHOW);
recall_array = zeros(1, SHOW);

% Total number of relevant items in the dataset.
total_relevant = sum(relevance);

% Compute precision and recall for each k in top 15 results.
for k = 1:SHOW
    relevant_retrieved = sum(relevance(dst(1:k, 2)));
    precision_at_k = relevant_retrieved / k;
    recall_at_k = relevant_retrieved / total_relevant;

    precision_array(k) = precision_at_k;
    recall_array(k) = recall_at_k;
    
    fprintf('Top %d results - Precision: %.2f, Recall: %.2f\n', k, precision_at_k, recall_at_k);
end

% Now, you can use the precision_array and recall_array for plotting.
figure;
plot(recall_array, precision_array, '-o');
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve');
grid on;

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
