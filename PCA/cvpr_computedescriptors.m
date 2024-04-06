%% cvpr_computedescriptors.m
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractSpatialGridColour2' to extract a descriptor from the
%% image.  script will generate a single .mat file with the entire dataset's descriptors, 
%% which is ready for PCA 

% Close any open figures and clear the workspace
close all;
clear all;

%% Configuration Section

% Specify the path where the MSRCv2 dataset images are stored
DATASET_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2';

% Define the root folder where descriptors will be saved
OUT_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\pca1';

% Specify a subfolder within OUT_FOLDER to store the PCA descriptors.
%OUT_SUBFOLDER = 'pca1';

%% Main Processing Section

% Obtain a list of all BMP images in the dataset folder
allfiles = dir(fullfile([DATASET_FOLDER, '/Images/*.bmp']));

% Initialize a matrix to hold all descriptors, with 591 rows (one for each image)
% and 1024 columns (one for each feature in the descriptor).
all_descriptors = zeros(591, 1024);

% Loop over each image in the dataset
for filenum = 1:length(allfiles)
    % Extract the filename of the current image
    fname = allfiles(filenum).name;
    
    % Display progress information in the command window
    fprintf('Processing file %d/%d - %s\n', filenum, length(allfiles), fname);
    
    % Start a timer to measure the processing time for the current image
    tic;
    
    % Construct the full path to the current image
    imgfname_full = fullfile(DATASET_FOLDER, 'Images', fname);
    
    % Load the image, convert pixel values to double precision, and normalize them to [0, 1]
    img = double(imread(imgfname_full)) / 255;
    
    % Extract descriptor from the image using the appropriate function
    F = extractSpatialGridColour2(img);
    
    % Append the descriptor to the 'all_descriptors' matrix
    all_descriptors(filenum, :) = F;
    
    % Stop the timer and display the elapsed time for processing the current image
    toc
end

% Save the matrix of all descriptors
save(fullfile(OUT_FOLDER, 'all_descriptors.mat'), 'all_descriptors');
