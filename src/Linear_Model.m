% Check if 'data' is a table
if ~istable(data)
    error('The variable ''data'' must be a table.');
end

% Choose a column for prediction (change the index as needed)
targetColumnIndex = 2;
targetSeries = data.(targetColumnIndex);

% Create lagged features for time series prediction
numLags = 20; % Number of lagged observations to use as features
laggedData = lagmatrix(targetSeries, 1:numLags); % Create lagged matrix

% Remove rows with NaN values created by lagging
laggedData = laggedData(numLags+1:end, :);
targetSeries = targetSeries(numLags+1:end);

% Split the data into training and testing sets
cv = cvpartition(length(targetSeries), 'HoldOut', 0.2); % 20% holdout for testing
trainingFeatures = laggedData(training(cv), :);
trainingTargets = targetSeries(training(cv));
testingFeatures = laggedData(test(cv), :);
testingTargets = targetSeries(test(cv));

% Ensure trainingFeatures and trainingTargets are numeric matrices
if istable(trainingFeatures)
    trainingFeatures = table2array(trainingFeatures); % Convert table to array
end
if istable(trainingTargets)
    trainingTargets = table2array(trainingTargets); % Convert table to vector
    trainingTargets = trainingTargets(:); % Ensure trainingTargets is a column vector
end

% Similarly, ensure testingFeatures and testingTargets are numeric for predictions
if istable(testingFeatures)
    testingFeatures = table2array(testingFeatures);
end
if istable(testingTargets)
    testingTargets = table2array(testingTargets);
    testingTargets = testingTargets(:);
end

% Create and train a linear regression model using the training data
model = fitlm(trainingFeatures, trainingTargets);

% Make predictions on the testing data
predictions = predict(model, testingFeatures);

% Display the model and RMSE
disp(model);
mse = mean((predictions - testingTargets).^2);
rmse = sqrt(mse);
disp(['Root Mean Squared Error (RMSE): ', num2str(rmse)]);

% Plot the actual vs. predicted values for the testing data
figure;
plot(testingTargets, 'b', 'LineWidth', 1.5);
hold on;
plot(predictions, 'r', 'LineWidth', 1.5);
xlabel('Date');
ylabel('Target Value');
title('Time Series Prediction');
legend('Actual Value', 'Predicted Value');
grid on;
