% evaluate.m

% Define paths for dataset and descriptor storage.
DESCRIPTOR_FOLDER = 'C:\Users\Abdullah\Desktop\Computer Vision & Pattern Recognition\CV-PR-\descriptors';

% Load the saved evaluation data
load(fullfile(DESCRIPTOR_FOLDER, 'evaluation_data.mat'));

% Initialize Arrays for precision and recall.
precision_array = zeros(1, SHOW);
recall_array = zeros(1, SHOW);

% Total number of relevant items in the dataset.
total_relevant = sum(relevance);

% Compute precision and recall for each k in top SHOW results.
for k = 1:SHOW
    relevant_retrieved = sum(relevance(dst(1:k, 1)));
    precision_at_k = relevant_retrieved / k;
    recall_at_k = relevant_retrieved / total_relevant;

    precision_array(k) = precision_at_k;
    recall_array(k) = recall_at_k;

    fprintf('Top %d results - Precision: %.2f, Recall: %.2f\n', k, precision_at_k, recall_at_k);
end

% Plot the precision-recall curve.
figure;
plot(recall_array, precision_array, '-o');
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve');
grid on;
