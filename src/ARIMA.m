
data=data1;
filename = 'DataTable.xlsx'; 
writetable(data, filename);
numTimeSteps = 100;
priceData = data.Aluminum995MinimumPurityLMESpotPriceCIFUKPortsUSPerMetricTon;

% Define hyperparameters
p = 1;  % Order of the autoregressive (AR) component
d = 1;  % Degree of differencing
q = 1;  % Order of the moving average (MA) component
forecastHorizon = 10;  % Number of future time steps to forecast

% Split the dataset into training and testing data
trainingData = priceData(1:end-forecastHorizon);
testingData = priceData(end-forecastHorizon+1:end);

% Fit an ARIMA model to the training data
arimaModel = arima(p, d, q);
fitModel = estimate(arimaModel, trainingData);

% Forecast future values using the fitted model
forecastedValues = forecast(fitModel, forecastHorizon, 'Y0', testingData);

% Calculate evaluation metrics (e.g., RMSE)
rmse = sqrt(mean((forecastedValues - testingData).^2));
fprintf('Root Mean Squared Error (RMSE): %.4f\n', rmse);

% Plot actual vs. forecasted prices
figure;
plot(priceData, 'b', 'LineWidth', 1.5, 'DisplayName', 'Actual Prices');
hold on;
plot([1:numel(trainingData), (numel(trainingData)+1):(numel(trainingData)+forecastHorizon)], ...
     [trainingData; forecastedValues], 'r', 'LineWidth', 1.5, 'DisplayName', 'Forecasted Prices');
xlabel('Time Step');
ylabel('Price');
title('Commodity Price Prediction with ARIMA');
legend('show');
grid on;
