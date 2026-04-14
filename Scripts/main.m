function main
    % Define samples
    [nomTrain, nomVal, nomTest, intVal, intTest] = getFiles;
    
    % List nominal & intruder speakers
    printSpeakers(nomTest, intTest)

    %% Extract features | Output is array of data from windows
    % Nominal Train | Nominal Val | Intruder Val
    [nomTrainFeatures, nomTrainLabels]  = extractFeatures(nomTrain);

    % Train model
    classifier = trainFeatures(nomTrainFeatures, nomTrainLabels,33);

    % Validation    --- TODO
    [percentage, k] = validation(nomTrainFeatures, nomTrainLabels, nomTest, intVal);

    % Test model
    [nomAccuracy, nomCount]= testModel(classifier, nomTest, 'Nominal');
    % nomAccuracy = testModel(classifier, nomTrain, 'Nominal');
    [intAccuracy, intCount] = testModel(classifier, intTest, 'Intruder');

    % Print results
    totalAccuracy = (nomAccuracy*nomCount + intAccuracy*intCount) / (nomCount+intCount);
    fprintf('Model is %.1f%% Accurate \n', totalAccuracy);
    fprintf('--Nominal test accuracy:   %.1f%% \n', nomAccuracy);
    fprintf('--Intruder test accuracy:  %.1f%% \n', intAccuracy);