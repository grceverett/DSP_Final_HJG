function [scoreAvg,scoredstd] = validateModel(classifier, Datastore, expectedType)
    % Loop through each file in the datastore
    numFiles = length(Datastore.Files);
    correct = 0;
    
    for i = 1:numFiles
        % Create mini-datastore for just the current file
        singleFile = subset(Datastore, i);
        
        % Extract features for this specific file
        fileFeatures = extractFeatures(singleFile);
        
        % Predict the label for every window in the file
        [predictions, scores] = predict(classifier, fileFeatures);
        
        % Calculate intruder threshold per window
        maxScores = max(scores, [], 2);
        scoreAvg(i) = mean(maxScores);
        scoredstd(i) = std(maxScores);
        
    end
        