function [percentage, k] = validation(nomTrainFeatures, nomTrainLabels, nomTest, intVal)
%
% 
%
% 


for n = 1:10
    k = 2^n + 1;

    % Train classifier
    classifier = trainFeatures(nomTrainFeatures, nomTrainLabels, k);

    % --- Nominal ---
    [nomAcc, nomStdVals] = validateModel(classifier, nomTest);
    nominalAvg(n) = mean(nomAcc)
    nominalStdArr(n) = mean(nomStdVals);

    % --- Intruder ---
    [intAcc, intStdVals] = validateModel(classifier, intVal);
    intruderAvg(n) = mean(intAcc)
    intruderStdArr(n) = mean(intStdVals);

    % --- Compute gap ---
    gap = abs(nominalAvg(n) - intruderAvg(n))

    % --- Average std ---
    avgStd = (nominalStdArr(n) + intruderStdArr(n)) / 2

    % --- Final score ---
    score(n) = gap -  0.8*avgStd;
end

% Best model = largest separation with low variance
[~, bestIdx] = max(score);

best_k = 2^bestIdx + 1;
percentage = intruderAvg(bestIdx); % Taking the bottom works the best

% Display
fprintf('Best n: %d\n', bestIdx);
fprintf('Best k: %d\n', best_k);
fprintf('Gap: %.4f\n', abs(nominalAvg(bestIdx) - intruderAvg(bestIdx)));
fprintf('Final Accuracy: %.4f\n', percentage);