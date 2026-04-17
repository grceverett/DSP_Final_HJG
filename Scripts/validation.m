% validation - Selects the best KNN classifier and decision threshold using
%              a nominal vs. intruder separation strategy.
%
% Inputs:
%   nomTrainFeatures - Feature matrix used to train the classifier
%   nomTrainLabels   - Class labels corresponding to nomTrainFeatures
%   nomTest          - Nominal samples (known/expected class) used for validation
%   intVal           - Intruder samples (out-of-set class) used for validation
%
% Outputs:
%   classifier     - Trained KNN classifier using the best k found
%   bestThreshold  - Decision threshold that maximizes weighted accuracy
%   k              - Final k value used in the best classifier
function [classifier,bestThreshold, k] = validation(nomTrainFeatures, nomTrainLabels, nomTest, intVal)

% Try k values of the form 2^n + 1 for n = 1 to 10
for n = 1:10
    k = 2^n + 1;
% Train classifier
    classifier = trainFeatures(nomTrainFeatures, nomTrainLabels, k);

% --- Nominal ---
    % Validate classifier on nominal test set and store mean accuracy and std
    [nomAcc, nomStdVals] = validateModel(classifier, nomTest);
    nominalAvg(n) = mean(nomAcc)
    nominalStdArr(n) = mean(nomStdVals);

% --- Intruder ---
    % Validate classifier on intruder set and store mean accuracy and std
    [intAcc, intStdVals] = validateModel(classifier, intVal);
    intruderAvg(n) = mean(intAcc)
    intruderStdArr(n) = mean(intStdVals);

% --- Compute gap ---
    % Larger gap means the classifier better separates nominal from intruder
    gap = abs(nominalAvg(n) - intruderAvg(n))

% --- Average std ---
    % Average spread across both sets; lower is more consistent
    avgStd = (nominalStdArr(n) + intruderStdArr(n)) / 2

% --- Final score ---
    % Reward separation, penalize variance
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

% Retrain final classifier using the full training set with best k
classifier = trainFeatures(nomTrainFeatures, nomTrainLabels, best_k);

% --- STEP 1: Coarse search ---
% Sweep thresholds from 0.1 to 0.9 in steps of 0.1
thresholds = 0.1:0.1:0.9;

for i = 1:length(thresholds)
    % Test both sets at this threshold
    [nomAcc, ~] = testModel(classifier, nomTest, "Nominal", thresholds(i));
    [intAcc, ~] = testModel(classifier, intVal, "Intruder", thresholds(i));

    % Weighted accuracy: nominal set has 20 samples, intruder has 8
    accuracies(i) = (20*nomAcc + 8*intAcc) /28;
    fprintf('Threshold %.2f -> Accuracy %.2f%%\n', thresholds(i), accuracies(i));
end

% --- Plot Coarse Search Accuracies ---
figure;
plot(thresholds, accuracies, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
xlabel('Threshold');
ylabel('Weighted Accuracy (%)');
title('Coarse Threshold Search');
grid on;

% --- STEP 2: Find the best two points ---
% Sort thresholds by accuracy and pick the top two for fine search bounds
[~, idx] = sort(accuracies, 'descend');
t1 = thresholds(idx(1));
t2 = thresholds(idx(2));

% Ensure t1 is the lower bound and t2 is the upper bound
if(t1>t2)
    hold = t2;
    t2=t1;
    t1=hold;
end

fprintf('\nRefining between %.2f and %.2f\n', t1, t2);

% --- STEP 3: Fine search ---
% Search 20 evenly spaced thresholds between the two best coarse values
fineThresholds = linspace(t1, t2+0.1, 20);

for i = 1:length(fineThresholds)
    [nomAcc, ~] = testModel(classifier, nomTest, "Nominal", fineThresholds(i));
    [intAcc, ~] = testModel(classifier, intVal, "Intruder", fineThresholds(i));

    % Weighted accuracy using same sample counts as coarse search
    fineAcc(i) = (20*nomAcc + 8*intAcc) / 28;
end

% --- Plot Fine Search Accuracies ---
figure;
plot(fineThresholds, fineAcc, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'r');
xlabel('Threshold');
ylabel('Weighted Accuracy (%)');
title('Fine Threshold Search');
grid on;

% --- STEP 4: Best result ---
% Select the threshold that achieved the highest weighted accuracy
[bestAccuracy, bestIdx] = max(fineAcc);
bestThreshold = fineThresholds(bestIdx);

fprintf('\nBest Threshold: %.4f\n', bestThreshold);
fprintf('Best Accuracy: %.2f%%\n', bestAccuracy);
end