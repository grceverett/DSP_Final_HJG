function [classifier,bestThreshold, k] = validation(nomTrainFeatures, nomTrainLabels, nomTest, intVal)
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
% Subtracting the standard deviation fromt the nominal average to find the
% best percentage.
percentage = nominalAvg(bestIdx)-nominalStdArr(n); 

% Display
fprintf('Best n: %d\n', bestIdx);
fprintf('Best k: %d\n', best_k);
fprintf('Final Accuracy: %.4f\n', percentage);

classifier = trainFeatures(nomTrainFeatures, nomTrainLabels, best_k);

% --- STEP 1: Coarse search ---
thresholds = 0.1:0.1:0.9;

for i = 1:length(thresholds)

    [nomAcc, ~] = testModel(classifier, nomTest, "Nominal", thresholds(i));
    [intAcc, ~] = testModel(classifier, intVal, "Intruder", thresholds(i));

    accuracies(i) = (20*nomAcc + 8*intAcc) /28;

    fprintf('Threshold %.2f -> Accuracy %.2f%%\n', thresholds(i), accuracies(i));
end

% --- STEP 2: Find best two neighbors ---
[~, idx] = sort(accuracies, 'descend');

t1 = thresholds(idx(1));
t2 = thresholds(idx(2));
if(t1>t2)
    hold = t2;
    t2=t1;
    t1=hold;
end

fprintf('\nRefining between %.2f and %.2f\n', t1, t2);

% --- STEP 3: Fine search ---
fineThresholds = linspace(t1, t2+0.1, 20);

for i = 1:length(fineThresholds)
    [nomAcc, ~] = testModel(classifier, nomTest, "Nominal", fineThresholds(i));
    [intAcc, ~] = testModel(classifier, intVal, "Intruder", fineThresholds(i));

    fineAcc(i) = (20*nomAcc + 8*intAcc) / 28;
end

% --- STEP 4: Best result ---
[bestAccuracy, bestIdx] = max(fineAcc);
bestThreshold = fineThresholds(bestIdx);

fprintf('\nBest Threshold: %.4f\n', bestThreshold);
fprintf('Best Accuracy: %.2f%%\n', bestAccuracy);

end