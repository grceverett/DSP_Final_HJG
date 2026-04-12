function fileNames
    % Tr - Train | Vd - Validation | Ts - Test
    % N - Nominal | I - Intruder/NonNominal
    % P - Path

    TrP     = '../Data/Training/';
    VdNP    = '../Data/Validation/Nominal/';
    TsNP    = '../Data/Test/Nominal/';
    VdIP    = '../Data/Validation/Intruder/';
    TsIP    = '../Data/Test/Intruder/';
    ext     = '.m4a';

    training            = audioDatastore(TrP,   "FileExtensions", ext, 'LabelSource', 'foldernames');
    countEachLabel(training)
    nominalValidation   = audioDatastore(VdNP,  "FileExtensions", ext);
    nominalTesting      = audioDatastore(TsNP,  "FileExtensions", ext);
    intruderValidation  = audioDatastore(VdIP,  "FileExtensions", ext);
    intruderTesting     = audioDatastore(TsIP,  "FileExtensions", ext);