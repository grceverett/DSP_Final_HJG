function [nomTrain, nomVal, nomTest, intVal, intTest] = getFiles
    % Path definitions
    nomPath = '../Data/Nominal/';
    intPath = '../Data/Intruder/';
    ext     = '.m4a';

    % Extract files
    nomFiles = audioDatastore(nomPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames', 'FileExtensions', '.m4a');
    intFiles = audioDatastore(intPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames', 'FileExtensions', '.m4a');

    % Nominal 
    % Training - 3 | Validation - 2 | Test - 2
    [nomTrain, nomVal, nomTest] = splitEachLabel(nomFiles, 0.4, 0.3);

    % Intruder
    % Validation - 2 | Test - 2
    [intVal, intTest] = splitEachLabel(intFiles, 0.5);