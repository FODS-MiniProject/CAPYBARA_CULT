% Load full emotion dataset
data = readtable('emotion_dataset_noisy.csv');

% --- SFDS: Data Cleaning ---

% Check for missing values
missing_counts = sum(ismissing(data));
fprintf('Missing values per column:\n');
disp(missing_counts);

% If missing data exists, impute with column median (numeric cols only)
numeric_vars = varfun(@isnumeric, data, 'OutputFormat', 'uniform');
for i = 1:width(data)
    if missing_counts(i) > 0 && numeric_vars(i)
        col = data{:,i};
        col(missing(col)) = median(col(~missing(col)));
        data{:,i} = col;
    end
end

% Outlier detection and handling using IQR method for numeric features
features_raw = data{:, 2:end};  % excluding label column
for col = 1:size(features_raw, 2)
    Q1 = quantile(features_raw(:,col), 0.25);
    Q3 = quantile(features_raw(:,col), 0.75);
    IQR = Q3 - Q1;
    lower_bound = Q1 - 1.5 * IQR;
    upper_bound = Q3 + 1.5 * IQR;
    
    % Cap outliers at bounds (winsorization)
    features_raw(features_raw(:,col) < lower_bound, col) = lower_bound;
    features_raw(features_raw(:,col) > upper_bound, col) = upper_bound;
end

% Replace features with cleaned version
data{:, 2:end} = features_raw;

% --- SFDS: Exploratory Data Analysis (EDA) ---

% 1) Basic statistics of numeric features
stats = array2table([mean(features_raw); median(features_raw); std(features_raw)]', ...
    'VariableNames', {'Mean', 'Median', 'StdDev'}, ...
    'RowNames', data.Properties.VariableNames(2:end));
disp('Basic statistics for features:');
disp(stats);

% 2) Label distribution
figure;
label_counts = countcats(categorical(data{:,1}));
bar(label_counts);
xticklabels(categories(categorical(data{:,1})));
xtickangle(45);
ylabel('Count');
title('Label Distribution');

% 3) Feature histograms (for first 5 features to keep it simple)
figure;
for i = 1:min(5, size(features_raw,2))
    subplot(2,3,i);
    histogram(features_raw(:,i));
    title(data.Properties.VariableNames{i+1});
end
sgtitle('Feature Histograms');

% 4) Boxplots to visualize spread and outliers
figure;
boxplot(features_raw, 'Labels', data.Properties.VariableNames(2:end));
xtickangle(45);
title('Boxplots of Features');

% 5) Correlation heatmap of numeric features
corr_mat = corr(features_raw);
figure;
heatmap(data.Properties.VariableNames(2:end), data.Properties.VariableNames(2:end), corr_mat, ...
    'Colormap', parula, 'ColorLimits', [-1 1], 'Title', 'Feature Correlation Heatmap');

% --- Your original pipeline starts here ---

% Separate features and labels
features = data{:,2:end};                
labels = categorical(data{:,1});         

% Normalize features
features = normalize(features);

% Train-test split (70-30)
cv = cvpartition(labels, 'HoldOut', 0.3);
trainIdx = training(cv);
testIdx = test(cv);

X_train = features(trainIdx, :);
X_test = features(testIdx, :);
y_train = labels(trainIdx);
y_test = labels(testIdx);

svm = fitcecoc(X_train, y_train);
pred_svm = predict(svm, X_test);
acc_svm = mean(pred_svm == y_test) * 100;

figure;
confusionchart(y_test, pred_svm);
title(sprintf('SVM Confusion Matrix (Accuracy: %.2f%%)', acc_svm));

tree = fitctree(X_train, y_train);
pred_tree = predict(tree, X_test);
acc_tree = mean(pred_tree == y_test) * 100;

figure;
confusionchart(y_test, pred_tree);
title(sprintf('Decision Tree Confusion Matrix (Accuracy: %.2f%%)', acc_tree));

rf = TreeBagger(100, X_train, y_train, 'OOBPrediction', 'On', 'Method', 'classification');
pred_rf = predict(rf, X_test);
pred_rf = categorical(pred_rf); 
acc_rf = mean(pred_rf == y_test) * 100;

figure;
confusionchart(y_test, pred_rf);
title(sprintf('Random Forest Confusion Matrix (Accuracy: %.2f%%)', acc_rf));

ens = fitcensemble(X_train, y_train, 'Method', 'Bag');
pred_ens = predict(ens, X_test);
acc_ens = mean(pred_ens == y_test) * 100;

figure;
confusionchart(y_test, pred_ens);
title(sprintf('Ensemble Confusion Matrix (Accuracy: %.2f%%)', acc_ens));

[coeff, score] = pca(features);
figure;
gscatter(score(:,1), score(:,2), labels);
title('PCA of Emotion Dataset');
xlabel('Principal Component 1');
ylabel('Principal Component 2');

figure;
bar(tree.predictorImportance);
xticklabels(data.Properties.VariableNames(2:end));
xtickangle(45);
ylabel('Importance Score');
title('Feature Importance (Decision Tree)');

fprintf('SVM Accuracy: %.2f%%\nDecision Tree Accuracy: %.2f%%\nRandom Forest Accuracy: %.2f%%\nEnsemble Accuracy: %.2f%%\n', ...
    acc_svm, acc_tree, acc_rf, acc_ens);

