%% cvpr_computedescriptors.m
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.

% Close any open figures and clear the workspace
close all;
clear all;

%% Configuration Section

% Specify the path where the MSRCv2 dataset images are stored
DATASET_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2';

% Define the root folder where descriptors will be saved
OUT_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors';

% Specify a subfolder within OUT_FOLDER to store the descriptors. 
% This organization allows for multiple types of descriptors to be stored separately within the main descriptor directory.
OUT_SUBFOLDER='globalRGBhisto';

%% Main Processing Section

% Obtain a list of all BMP images in the dataset folder
allfiles=dir(fullfile([DATASET_FOLDER,'/Images/*.bmp']));

% Loop over each image in the dataset
for filenum=1:length(allfiles)
    % Extract the filename of the current image
    fname=allfiles(filenum).name;
    
    % Display progress information in the command window
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    
    % Start a timer to measure the processing time for the current image
    tic;
    
    % Construct the full path to the current image
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    
    % Load the image, convert pixel values to double precision, and normalize them to [0, 1]
    img=double(imread(imgfname_full))./255;
    
    % Define the output filename for saving the descriptor. The .bmp extension is replaced with .mat.
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];
    
    % Extract descriptor from the image using the 'extractRandom' function
    F=extractRandom(img);
    
    % Save the computed descriptor to the specified output file
    save(fout,'F');
    
    % Stop the timer and display the elapsed time for processing the current image
    toc
end
