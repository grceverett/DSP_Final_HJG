function [features, labels] = extractFeatures(audioFiles)
    % Extract features from audio
    fs = 48000; % Confirmed same sample rate
    windowLength    = round(0.03 * fs); % 30ms analysis window
    overlapLength   = round(0.015 * fs); % 50 percent overlap (15ms)
    aFE = audioFeatureExtractor( ...
        Window=hanning(windowLength,"periodic"),...
        OverlapLength=overlapLength,            ...
        SampleRate=fs,                          ...
        mfcc=true,                              ...
        shortTimeEnergy=true,                   ...
        zerocrossrate=true                      ...
    );
    fMap = info(aFE); % Referencing this simply produces an index

    features        = [];
    labels          = [];
    allFeatures     = extract(aFE, audioFiles);
    allLabels       = audioFiles.Labels;
    for i = 1:length(allFeatures)
        currFeature = allFeatures{i};

        % Remove zerocrossrate and shortTimeEnergy
        currFeature(:, [fMap.zerocrossrate, fMap.shortTimeEnergy]) = [];
        
        % Label every window
        label = repelem(allLabels(i), size(currFeature,1));

        % Compile features and labels for all people
        features    = [features; currFeature];
        labels      = [labels, label];
    end