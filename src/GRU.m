
%  Load the data from Excel
%data = readtable('DataTable.xlsx');
dataNon=non_normalized_data2;
%  Select commodities as variables
commodity1 = dataNon.Aluminum995MinimumPurityLMESpotPriceCIFUKPortsUSPerMetricTon;
commodity2 = dataNon.GoldFixingCommitteeOfTheLondonBullionMarketAssociationLondon3PM;
% Add more commodities as needed

% Combine commodities into a matrix
commodityDataNon = [commodity1, commodity2]; % Add more commodities if you selected more

%  Split data into training and validation sets (e.g., 80% train, 20% validate)
numTimeStepsTrain = floor(0.8 * height(data));
XTrain = commodityDataNon(1:numTimeStepsTrain, :);
YTrain = commodityDataNon(2:numTimeStepsTrain+1, :);

XValidation = commodityDataNon(numTimeStepsTrain+1:end-1, :);
YValidation = commodityDataNon(numTimeStepsTrain+2:end, :);

% Define and build the GRU network
numFeatures = size(commodityDataNon, 2);
numHiddenUnits = 1000;

layers = [ ...
    sequenceInputLayer(numFeatures)
    gruLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numFeatures)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',200, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',50, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

%  Train the GRU network
net = trainNetwork(XTrain',YTrain',layers,options);

%  Evaluate & Predict
YPred = predict(net,XValidation');

% Calculate prediction error
predictionError = YValidation - YPred';

% Compute Mean Squared Error (MSE)
mseCommodity1 = mean((predictionError(:, 1)).^2);
mseCommodity2 = mean((predictionError(:, 2)).^2);

% Display the MSE
fprintf('Mean Squared Error for Commodity 1: %f\n', mseCommodity1);
fprintf('Mean Squared Error for Commodity 2: %f\n', mseCommodity2);

% Concatenate training targets and predictions for full visualization
fullTargets = [YTrain; YValidation];
fullPredictions = [YTrain; YPred'];

% Plot the prediction vs actual data for evaluation
figure;
subplot(2,1,1);
plot(fullTargets(:, 1));
hold on;
plot(fullPredictions(:, 1), '--');
legend('Actual', 'Predicted');
title('Commodity 1 Prediction');

subplot(2,1,2);
plot(fullTargets(:, 2));
hold on;
plot(fullPredictions(:, 2), '--');
legend('Actual', 'Predicted');
title('Commodity 2 Prediction');

% Number of future time steps to forecast
numForecastSteps = 1; % e.g., 12 for forecasting a year into the future

% Initialize the forecast results array
forecastResults = zeros(numForecastSteps, numFeatures);

% Use the last data from the validation set as the starting point
currentInput = XValidation(end, :);

for i = 1:numForecastSteps
    % Forecast the next step
    nextStepForecast = predict(net, currentInput');
    
    % Store the forecasted results
    forecastResults(i, :) = nextStepForecast';
    
    % Use the forecasted value as input for predicting the next step
    currentInput = [currentInput(2:end, :); nextStepForecast'];
end

% Plot the forecasted results
figure;
subplot(2,1,1);
plot(YValidation(:, 1));
hold on;
plot([YValidation(:, 1); forecastResults(:, 1)], '--');
legend('Actual', 'Forecasted');
title('Commodity 1 Forecast');

subplot(2,1,2);
plot(YValidation(:, 2));
hold on;
plot([YValidation(:, 2); forecastResults(:, 2)], '--');
legend('Actual', 'Forecasted');
title('Commodity 2 Forecast');
