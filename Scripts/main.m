function main
    % Define samples
    [nomTrain, nomVal, nomTest, intVal, intTest] = getFiles;
    
    % List nominal & intruder speakers
    printSpeakers(nomTest, intTest)

    % Extract features | Output is array of data from windows
    [features, labels] = extractFeatures(nomTrain);


    % Train model   --- TODO

    % Test model    --- TODO
    
