
data=data1;
% Step 2: Select the variable from the dataset 
selectedVariable = data.Aluminum995MinimumPurityLMESpotPriceCIFUKPortsUSPerMetricTon;

windowSize = 10;
movingAvg = movmean(selectedVariable, windowSize);

% Plot the original data and the moving average
figure;
plot(data.Date, selectedVariable, 'b', 'LineWidth', 1);
hold on;
plot(data.Date, movingAvg, 'r', 'LineWidth', 1.5);
xlabel('Date');
ylabel('Value');
title('Moving Average Prediction');
legend('Original Data', 'Moving Average');
grid on;

% Predict future values by extending the moving average
futureDays = 30; % Number of days into the future you want to predict
lastDataPoint = selectedVariable(end);
futureValues = lastDataPoint + (0:(futureDays - 1)) * (movingAvg(end) - movingAvg(end - windowSize + 1)) / windowSize;

% Plot the predicted future values
nextDates = (data.Date(end) + days(1:futureDays)).'; % Create a date range for the future
plot(nextDates, futureValues, 'g', 'LineWidth', 1.5);
legend('Original Data', 'Moving Average', 'Predicted Future Values');