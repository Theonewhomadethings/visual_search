%% cvpr_computedescriptors.m
% This code will iterate through every image in the MSRCv2 dataset
% and call the function 'SIFTdescriptor' to extract SIFT descriptors from the
% image. Each image's descriptors will be saved in a separate .mat file.

% Close any open figures and clear the workspace
close all;
clear all;

%% Configuration Section

% Specify the path where the MSRCv2 dataset images are stored
DATASET_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2';

% Define the root folder where descriptors will be saved
OUT_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors\SIFT1';

% Ensure the output folder exists
if ~exist(OUT_FOLDER, 'dir')
    mkdir(OUT_FOLDER);
end

%% Main Processing Section

% Obtain a list of all BMP images in the dataset folder
allfiles = dir(fullfile(DATASET_FOLDER, 'Images', '*.bmp'));

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

    % Load the image, convert pixel values to double precision
    img = imread(imgfname_full);

    % Extract SIFT descriptors from the image using the SIFTdescriptor function
    [features, validPoints] = SIFTdescriptor(img);

    % Define the output filename for saving the descriptor
    fout = fullfile(OUT_FOLDER, [fname(1:end-4), '_SIFT.mat']);

    % Save the SIFT descriptors and their validPoints to the file
    save(fout, 'features', 'validPoints');

    % Stop the timer and display the elapsed time for processing the current image
    toc
end
