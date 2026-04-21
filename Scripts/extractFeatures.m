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
    %% DELETE THIS BLOCK AFTER YOU GET THE PLOT
    %% ---------------------------------------------------------------------
    % 1. Extract features for the first file specifically
    firstFileFeatures = allFeatures{1};
    
    % 2. Clean the data (removing ZCR and Energy just like in your loop)
    % This ensures columns 1, 2, and 3 are definitely the first 3 MFCCs
    firstFileFeatures(:, [fMap.zerocrossrate, fMap.shortTimeEnergy]) = [];
    
    % 3. Create a time axis
    % The hop size is (WindowLength - OverlapLength)
    hopSize = windowLength - overlapLength;
    numFrames = size(firstFileFeatures, 1);
    timeAxis = (0:numFrames-1) * (hopSize / fs);
    
    % 4. Plotting
    figure('Color', 'w');
    plot(timeAxis, firstFileFeatures(:, 1:3), 'LineWidth', 1.5);
    
    title('First Three MFCCs for File 1');
    xlabel('Time (seconds)');
    ylabel('Coefficient Value');
    legend('MFCC 1', 'MFCC 2', 'MFCC 3');
    grid on;
    %% ---------------------------------------------------------------------
    % 1. Extract features for the first file specifically
    firstFileFeatures = allFeatures{1};
    
    % 2. Clean the data (removing ZCR and Energy just like in your loop)
    % This ensures columns 1, 2, and 3 are definitely the first 3 MFCCs
    firstFileFeatures(:, [fMap.zerocrossrate, fMap.shortTimeEnergy]) = [];
    
    % 3. Create a time axis
    % The hop size is (WindowLength - OverlapLength)
    hopSize = windowLength - overlapLength;
    numFrames = size(firstFileFeatures, 1);
    timeAxis = (0:numFrames-1) * (hopSize / fs);
    
    % 4. Plotting
    figure('Color', 'w');
    plot(timeAxis, firstFileFeatures(:, 1:3), 'LineWidth', 1.5);
    
    title('First Three MFCCs for File 1');
    xlabel('Time (seconds)');
    ylabel('Coefficient Value');
    legend('MFCC 1', 'MFCC 2', 'MFCC 3');
    grid on;
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