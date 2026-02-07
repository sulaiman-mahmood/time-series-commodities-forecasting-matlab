% Data Preparation
dataTable=data1;
dates = dataTable.Date;
prices = dataTable.Aluminum995MinimumPurityLMESpotPriceCIFUKPortsUSPerMetricTon;

% Normalize prices
mu = mean(prices);
sigma = std(prices);
pricesNormalized = (prices - mu) / sigma;


% Convert data to sequences for LSTM
numTimeStepsTrain = floor(0.9 * numel(prices));
dataTrain = pricesNormalized(1:numTimeStepsTrain+1);
dataTest = pricesNormalized(numTimeStepsTrain+1:end);
% Define sequences
XTrain = dataTrain(1:end-1);
YTrain = dataTrain(2:end);
XTest = dataTest(1:end-1);
YTest = dataTest(2:end);
XTrain = reshape(XTrain, [1, 108, 1]);
YTrain = reshape(YTrain, [1, 108, 1]);
XTest = reshape(XTest, [1, numel(XTest), 1]);
% Find NaN indices in XTest
nanIndices = isnan(XTest);

% Use interpolation to fill missing values
XTest(nanIndices) = interp1(find(~nanIndices), XTest(~nanIndices), find(nanIndices), 'linear', 'extrap');
% Define LSTM Architecture with increased complexity
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 100; % Increased number of hidden units

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits, 'OutputMode', 'sequence') % Added a sequence output mode
    lstmLayer(numHiddenUnits) % Added an additional LSTM layer
    fullyConnectedLayer(numResponses)
    regressionLayer];

% Adjust training options
options = trainingOptions('adam', ...
    'MaxEpochs',400, ... % Increased epochs
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',1, ...
    'Plots','training-progress', ...
    'Shuffle', 'every-epoch'); % Added shuffle to mix training data every epoch

% Train the LSTM model
net = trainNetwork(XTrain,YTrain,layers,options);


% 4. Prediction
YPred = predict(net,XTest);

% De-normalize predictions
YPred = YPred * sigma + mu;
YTest = YTest * sigma + mu;


% 5. Forecast Future Values
numFutureSteps = 30;
futurePreds = zeros(numFutureSteps, 1);
sequenceLength = 10;
lastSequence = XTest(:, end-sequenceLength+1:end, :);  % Taking the last sequence from XTest
  % Taking the last sequence from XTest

for i = 1:numFutureSteps
    futureValue = predict(net, lastSequence);
    futureValueScalar = futureValue(end);  % Taking the last value from the predicted sequence
    futurePreds(i) = futureValueScalar;
    lastSequence = cat(2, lastSequence(:, 2:end, :), reshape(futureValueScalar, [1, 1, numFeatures]));
end

% De-normalize future predictions
futurePreds = futurePreds * sigma + mu;

% 6. Plotting
figure
plot(dates(numTimeStepsTrain+2:end), YTest)
hold on
plot(dates(numTimeStepsTrain+2:end), YPred)
% Assuming dates are in datetime format; creating future dates
futureDates = dates(end) + days(1:numFutureSteps); 
plot(futureDates, futurePreds, '--')  % Plotting future predictions with dashed lines
xlabel('Date')
ylabel('Commodity Price')
legend({'Actual', 'Predicted', 'Forecasted'})
title('Forecast with LSTM')
hold off

% 1. Calculate RMSE
rmse = sqrt(mean((YPred - YTest).^2));

% 2. Calculate MAE
mae = mean(abs(YPred - YTest));

% 3. Calculate R^2 Score
SStotal = (length(YTest) - 1) * var(YTest);
SSres = sum((YPred - YTest).^2);
r2 = 1 - SSres / SStotal;

% Display the metrics
disp(['RMSE: ', num2str(rmse)]);
disp(['MAE: ', num2str(mae)]);
disp(['R^2 Score: ', num2str(r2)]);


% Visualization of Residuals (errors)
residuals = YPred - YTest;
figure
plot(dates(numTimeStepsTrain+2:end), residuals, 'r-')
xlabel('Date')
ylabel('Residual')
title('Residuals over Time')
legend({'Residuals'})

