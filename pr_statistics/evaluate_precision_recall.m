function evaluate_precision_recall(ALLFILES, dst, queryimg_filename, DESCRIPTOR_FOLDER, DESCRIPTOR_SUBFOLDER)
    % Initialize the total number of images and find the query image's index.
    NIMG = length(ALLFILES); % Total number of images in the dataset
    queryimg = find(strcmp(ALLFILES, queryimg_filename));  % Find the index of the query image in ALLFILES

    % Identify the relevant images based on the category of the query image.
    relevant_indices = find_relevant_indices(queryimg_filename, ALLFILES);

    % Load the feature descriptor for the query image.
    [~, queryimg_base, ~] = fileparts(queryimg_filename); % Extract the base filename (without path and extension)
    query_descriptor_file = fullfile(DESCRIPTOR_FOLDER, DESCRIPTOR_SUBFOLDER, [queryimg_base, '.mat']);
    load(query_descriptor_file, 'F'); % Load the feature descriptor for the query image
    query = F;

    % Initialize arrays for storing precision and recall values.
    topKs = [1, 5, 10, 15, NIMG]; % Different cut-offs for evaluation
    precision = [];
    recall = [];

    % Evaluate precision and recall for each cut-off in topKs.
    for K = topKs
        if K > size(dst,1)
            K = size(dst,1); % Adjust K if it's greater than the total retrieved images
        end
        retrieved_indices = dst(1:K, 2); % Get the indices of the top-K retrieved images
        TP = sum(ismember(retrieved_indices, relevant_indices)); % Count how many retrieved images are relevant

        prec = TP / K; % Calculate precision
        rec = TP / length(relevant_indices); % Calculate recall

        precision = [precision, prec]; % Store precision value
        recall = [recall, rec]; % Store recall value
    end

    % Plot the Precision-Recall Curve.
    figure;
    plot(recall, precision, '-o'); % Plot recall vs precision with circles marking each data point
    xlabel('Recall');
    ylabel('Precision');
    title('Precision-Recall Curve');
    grid on; % Add grid to the plot
end

% Supporting functions

function indices = find_relevant_indices(query_filename, ALLFILES)
    % Identify all images that belong to the same category as the query image.
    
    % Extract the category from the query image's filename
    category = extract_category(query_filename);
    
    % Find all images in ALLFILES that belong to the same category
    indices = find(cellfun(@(x) contains(x, category), ALLFILES));
end

function category = extract_category(filename)
    % Extract the image's category based on its filename. The category is identified
    % as the portion of the filename before the first underscore.
    
    underscore_positions = strfind(filename, '_'); % Find positions of underscores in the filename
    category = filename(1:underscore_positions(1)-1); % Extract the category from the filename
end
