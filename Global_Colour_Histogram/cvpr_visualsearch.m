% cvpr_visualsearch.m
% This script performs a visual search on the MSRCv2 dataset, extracting image descriptors,
% selecting a random image as a query, and visualizing the top similar images based on descriptor comparison.

% Close any open figures and clear workspace
close all;
clear all;

% Define paths for dataset and descriptor storage
% Set the path where the MSRCv2 dataset images are stored
DATASET_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\cwork_basecode\MSRC_ObjCategImageDatabase_v2';

% Set the root folder where image descriptors are saved
DESCRIPTOR_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors';

% Specific subfolder within DESCRIPTOR_FOLDER to store/read global RGB histogram descriptors
DESCRIPTOR_SUBFOLDER='globalRGBhisto';

% 1) Load image descriptors from storage
% Initialize matrices to store image descriptors and corresponding filenames
ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir(fullfile([DATASET_FOLDER,'/Images/*.bmp'])); % Get list of all BMP images in the dataset folder
for filenum=1:length(allfiles) 
    fname=allfiles(filenum).name;
    imgfname_full=fullfile(DATASET_FOLDER,'/Images/',fname);
    
    % Load image and normalize its pixel values to [0, 1]
    img=double(imread(imgfname_full))./255;

    % Construct filename to load descriptor (replace image extension with .mat)
    featfile=fullfile(DESCRIPTOR_FOLDER, DESCRIPTOR_SUBFOLDER, [fname(1:end-4), '.mat']);
    
    % Load descriptor from the file
    load(featfile,'F');
    
    % Store image filename and descriptor for later use
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

% 2) Randomly select an image as the query
NIMG=size(ALLFEAT,1);            % Total number of images in the collection
queryimg=floor(rand()*NIMG)+1;   % Randomly select an image index
queryimg_filename = ALLFILES{queryimg};  % Retrieve the filename of the selected query image

% 3) Compute distances between the query image and all other images in the dataset
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);       % Retrieve descriptor of the candidate image
    query=ALLFEAT(queryimg,:);    % Retrieve descriptor of the query image
    thedst=cvpr_compare(query,candidate);  % Compute distance between query and candidate
    
    % Store the computed distance and corresponding image index
    dst=[dst ; [thedst i]];

    % Debug code ignore Optionally, print distances for the first few images for debugging
   % if i <= 5  % Display distances for the first 5 images
    %    fprintf('Distance for image %d: %f\n', i, thedst);
    %end
end
dst=sortrows(dst,1); % Sort images by ascending distance to the query

% 4) Visualize the most similar images to the query
SHOW=15; % Number of top results to display
dst=dst(1:SHOW,:);
outdisplay=[];  % Initialize a matrix to hold the top result images
for i=1:size(dst,1)
    img=imread(ALLFILES{dst(i,2)});
    img=img(1:2:end,1:2:end,:);  % Downsample the image to a quarter of its original size
    img=img(1:81,:,:);  % Crop image to have a uniform vertical size (handle varying heights)
    outdisplay=[outdisplay img];
end

% Show the compiled result images
%imgshow(outdisplay);
imshow(outdisplay);
axis off;  % Hide axes for better visualization

% Store the filename of the query image (optional, for potential further use)
list_of_query_images = {queryimg_filename};
