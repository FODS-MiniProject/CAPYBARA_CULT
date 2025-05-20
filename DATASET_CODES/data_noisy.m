% Load the dataset
data = readtable('emotion_dataset1.csv');

% Extract labels (cell array of strings)
labels = data{:,1};  % cell array

% Get unique emotion labels
unique_labels = unique(labels);

% Set percentage of noisy labels (10%)
noise_fraction = 0.1;

% Number of labels to be changed
num_noisy_labels = round(noise_fraction * height(data));

% Randomly select indices for label noise
rand_indices = randperm(height(data), num_noisy_labels);

% Add noise by changing labels randomly (ensuring different from original)
for i = 1:length(rand_indices)
    current_label = labels{rand_indices(i)};
    new_label = current_label;
    while strcmp(new_label, current_label)
        new_label = unique_labels{randi(numel(unique_labels))};
    end
    labels{rand_indices(i)} = new_label;
end

% Replace original labels in the data table with noisy labels
data.emotion_label = labels;

% Save the noisy dataset (optional)
writetable(data, 'emotion_dataset_noisy.csv');
disp('Noisy dataset saved as emotion_dataset_noisy.csv');
