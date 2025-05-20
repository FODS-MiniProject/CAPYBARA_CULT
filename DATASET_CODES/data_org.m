emotions = { ...
    'Happy','Sad','Angry','Fear','Surprise','Disgust','Neutral', ...
    'Excited','Nervous','Bored','Confident','Embarrassed','Frustrated','Relaxed', ...
    'Happy_Nervous','Sad_Angry','Fear_Surprise','Disgust_Angry','Happy_Relaxed','Embarrassed_Nervous','Confident_Excited' ...
};

num_per_emotion = 100;
total_samples = numel(emotions) * num_per_emotion;

% Preallocate
mouth_width = zeros(total_samples,1);
eye_distance = zeros(total_samples,1);
eyebrow_raise = zeros(total_samples,1);
smile_intensity = zeros(total_samples,1);
frown_intensity = zeros(total_samples,1);
eye_openness = zeros(total_samples,1);  % New feature
mean_GSR = zeros(total_samples,1);
GSR_peaks = zeros(total_samples,1);
GSR_slope = zeros(total_samples,1);
emotion_label = strings(total_samples,1);

k = 1;
for ei = 1:length(emotions)
    emotion = emotions{ei};
    for j = 1:num_per_emotion
        emotion_label(k) = emotion;

        % Set fixed base values for each emotion class including eye_openness
        switch emotion
            case 'Happy'
                smile_intensity(k) = rand()*0.1 + 0.85;
                frown_intensity(k) = rand()*0.1 + 0.05;
                mean_GSR(k) = rand()*0.3 + 4.5;
                eyebrow_raise(k) = rand()*0.1 + 0.2;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Sad'
                smile_intensity(k) = rand()*0.05 + 0.05;
                frown_intensity(k) = rand()*0.2 + 0.75;
                mean_GSR(k) = rand()*0.3 + 1.5;
                eyebrow_raise(k) = rand()*0.1;
                eye_openness(k) = rand()*0.1 + 0.3;
            case 'Angry'
                smile_intensity(k) = rand()*0.05;
                frown_intensity(k) = rand()*0.2 + 0.8;
                mean_GSR(k) = rand()*0.3 + 4.7;
                eyebrow_raise(k) = rand()*0.1;
                eye_openness(k) = rand()*0.1 + 0.4;
            case 'Fear'
                eyebrow_raise(k) = rand()*0.1 + 0.7;
                mean_GSR(k) = rand()*0.3 + 5.0;
                frown_intensity(k) = rand()*0.1 + 0.4;
                smile_intensity(k) = rand()*0.1;
                eye_openness(k) = rand()*0.1 + 0.7;
            case 'Surprise'
                eyebrow_raise(k) = rand()*0.1 + 0.8;
                mouth_width(k) = rand()*2 + 40;
                mean_GSR(k) = rand()*0.2 + 4.8;
                smile_intensity(k) = rand()*0.1 + 0.3;
                eye_openness(k) = rand()*0.1 + 0.8;
            case 'Disgust'
                frown_intensity(k) = rand()*0.2 + 0.7;
                mean_GSR(k) = rand()*0.3 + 3.5;
                eyebrow_raise(k) = rand()*0.1 + 0.1;
                eye_openness(k) = rand()*0.1 + 0.3;
            case 'Neutral'
                smile_intensity(k) = rand()*0.05;
                frown_intensity(k) = rand()*0.05;
                mean_GSR(k) = rand()*0.2 + 2.5;
                eyebrow_raise(k) = rand()*0.05;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Excited'
                smile_intensity(k) = rand()*0.2 + 0.75;
                mean_GSR(k) = rand()*0.2 + 4.9;
                eyebrow_raise(k) = rand()*0.2 + 0.3;
                eye_openness(k) = rand()*0.1 + 0.6;
            case 'Nervous'
                frown_intensity(k) = rand()*0.2 + 0.6;
                mean_GSR(k) = rand()*0.2 + 4.0;
                eyebrow_raise(k) = rand()*0.2 + 0.5;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Bored'
                smile_intensity(k) = rand()*0.05;
                frown_intensity(k) = rand()*0.05;
                mean_GSR(k) = rand()*0.2 + 1.2;
                eye_openness(k) = rand()*0.1 + 0.4;
            case 'Confident'
                smile_intensity(k) = rand()*0.1 + 0.8;
                mean_GSR(k) = rand()*0.2 + 3.5;
                eyebrow_raise(k) = rand()*0.1 + 0.2;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Embarrassed'
                eyebrow_raise(k) = rand()*0.2 + 0.6;
                mean_GSR(k) = rand()*0.2 + 3.8;
                eye_openness(k) = rand()*0.1 + 0.4;
            case 'Frustrated'
                frown_intensity(k) = rand()*0.2 + 0.7;
                mean_GSR(k) = rand()*0.2 + 4.6;
                eye_openness(k) = rand()*0.1 + 0.4;
            case 'Relaxed'
                smile_intensity(k) = rand()*0.1 + 0.6;
                mean_GSR(k) = rand()*0.2 + 1.8;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Happy_Nervous'
                smile_intensity(k) = rand()*0.1 + 0.7;
                frown_intensity(k) = rand()*0.2 + 0.3;
                mean_GSR(k) = rand()*0.2 + 4.2;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Sad_Angry'
                frown_intensity(k) = rand()*0.2 + 0.8;
                mean_GSR(k) = rand()*0.2 + 4.2;
                eye_openness(k) = rand()*0.1 + 0.4;
            case 'Fear_Surprise'
                eyebrow_raise(k) = rand()*0.2 + 0.75;
                mean_GSR(k) = rand()*0.2 + 5.2;
                eye_openness(k) = rand()*0.1 + 0.75;
            case 'Disgust_Angry'
                frown_intensity(k) = rand()*0.2 + 0.75;
                mean_GSR(k) = rand()*0.2 + 4.3;
                eye_openness(k) = rand()*0.1 + 0.4;
            case 'Happy_Relaxed'
                smile_intensity(k) = rand()*0.1 + 0.8;
                mean_GSR(k) = rand()*0.2 + 2.5;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Embarrassed_Nervous'
                eyebrow_raise(k) = rand()*0.2 + 0.6;
                mean_GSR(k) = rand()*0.2 + 4.0;
                eye_openness(k) = rand()*0.1 + 0.5;
            case 'Confident_Excited'
                smile_intensity(k) = rand()*0.1 + 0.85;
                mean_GSR(k) = rand()*0.2 + 4.4;
                eye_openness(k) = rand()*0.1 + 0.6;
            otherwise
                eye_openness(k) = rand()*0.1 + 0.5;
        end

        % Shared features with small noise
        mouth_width(k) = rand()*5 + 30;
        eye_distance(k) = rand()*5 + 42;
        GSR_peaks(k) = randi([1,6]);
        GSR_slope(k) = randn()*0.1;

        k = k + 1;
    end
end

% Create dataset table including new feature
dataset = table(emotion_label, mouth_width, eye_distance, eyebrow_raise, ...
    smile_intensity, frown_intensity, eye_openness, mean_GSR, GSR_peaks, GSR_slope);

% Shuffle dataset
rng(42); % For reproducibility
dataset = dataset(randperm(height(dataset)), :);

% Save to CSV
writetable(dataset, 'emotion_dataset.csv');
disp('dataset saved as emotion_dataset.csv');
