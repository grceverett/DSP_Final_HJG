function [accuracy, numFiles] = testModel(classifier, testDatastore, expectedType)
    % Loop through each file in the datastore
    numFiles = length(testDatastore.Files);
    correct = 0;
    
    for i = 1:numFiles
        % Create mini-datastore for just the current file
        singleFile = subset(testDatastore, i);
        
        % Extract features for this specific file
        fileFeatures = extractFeatures(singleFile);
        
        % Handle cases where the file was pure silence/unvoiced
        if isempty(fileFeatures)
            fprintf('File %d (%s): No voiced speech detected.\n', i, expectedType);
            continue;
        end
        
        % Predict the label for every window in the file
        [predictions, scores] = predict(classifier, fileFeatures);
        
        % Calculate intruder threshold per window
        maxScores = max(scores, [], 2);
        isIntruder = maxScores < 0.48;
        
        % --- File-Level Estimate (Majority Vote) ---
        % Find percentage of frames flagged as intruder
        intruderRatio = sum(isIntruder) / length(isIntruder);
        
        fprintf('Testing %s File %i \n', expectedType, i);
        [uselessVar, name, ext] = fileparts(singleFile.Files{1});
        fprintf('--File: %s%s\n', name, ext);
        
        % If more than 50% of the frames are below confidence, flag as Intruder
        if intruderRatio > 0.5
            fprintf('--Estimate: INTRUDER (%.1f%% of frames were below confidence threshold)\n\n', intruderRatio * 100);
            if expectedType == "Intruder"
                correct = correct + 1;
            end
        else
            % Find the most common nominal speaker prediction among the confident frames
            validPredictions = predictions(~isIntruder);
            estimatedSpeaker = string(mode(validPredictions));
            fprintf('--Estimate: NOMINAL (%s) (%.1f%% confident)\n\n', estimatedSpeaker, (1 - intruderRatio) * 100);
            if expectedType == "Nominal"
                correct = correct + 1;
            end
        end
    end
    accuracy = 100 * correct / (numFiles);
end