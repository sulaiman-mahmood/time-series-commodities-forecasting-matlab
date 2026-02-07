datatable1=data1;
summaryStats=summary(datatable1);
disp(summaryStats);% check summary

missingValues=sum(ismissing(datatable1));
disp(missingValues);% check for missing values

%select three random commodities
selectedCommodity1=datatable1.Aluminum995MinimumPurityLMESpotPriceCIFUKPortsUSPerMetricTon;
selectedCommodity2=datatable1.CrudeOilpetroleumPriceIndex2016100SimpleAverageOfThreeSpotPric1;
selectedCommodity3=datatable1.GoldFixingCommitteeOfTheLondonBullionMarketAssociationLondon3PM;

% plotting data trends for the selected commodities
figure;
hold on;
plot(datatable1.Date, selectedCommodity1);
plot(datatable1.Date, selectedCommodity2);
plot(datatable1.Date, selectedCommodity3);
% Add more commodities as needed
xlabel('Date');
ylabel('Normalized Price');
legend('Crude oil', 'Aluminum','Gold'); % Add more commodities to the legend as needed
hold off;
%correlation heatmap
corrMatrix = [selectedCommodity1, selectedCommodity2, selectedCommodity3]; 

% Calculate the correlation matrix
correlationMatrix = corr(corrMatrix, 'Rows', 'complete');

% Visualize the correlation matrix using a heatmap
figure;
CommodityNames = {'Crude Oil', 'Aluminum', 'Gold'}; 
heatmap(CommodityNames, CommodityNames, correlationMatrix, 'Colormap', jet);
title('Correlation Matrix for Selected Commodities');

%outlier Detection
figure;
boxplot(corrMatrix, 'Labels', CommodityNames, 'Whisker', 1.5);
title('Box Plots for Outlier Detection');
ylabel('Value');
grid on;
set(gca, 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.5);

%distribution analysis of normalized prices
figure;

% Histogram for first variable in dataMatrix
subplot(3,1,1);
histogram(corrMatrix(:,1), 'Normalization', 'probability', 'FaceColor', [0.2, 0.6, 0.8]);
title('Histogram for Crude Oil');
xlabel('Value');
ylabel('Probability');
grid on;

% Histogram for second variable in dataMatrix
subplot(3,1,2);
histogram(corrMatrix(:,2), 'Normalization', 'probability', 'FaceColor', [0.2, 0.6, 0.8]);
title('Histogram for Aluminum');
xlabel('Value');
ylabel('Probability');
grid on;

% Histogram for third variable in dataMatrix
subplot(3,1,3);
histogram(corrMatrix(:,3), 'Normalization', 'probability', 'FaceColor', [0.2, 0.6, 0.8]);
title('Histogram for Gold');
xlabel('Value');
ylabel('Probability');
grid on;

% volatility analysis
windowSize = 12;  % Set to desired window size, e.g., 12 for 12 months

% Calculate rolling standard deviation for each variable in dataMatrix
volatilityVar1 = movstd(corrMatrix(:,1), windowSize);
volatilityVar2 = movstd(corrMatrix(:,2), windowSize);
volatilityVar3 = movstd(corrMatrix(:,3), windowSize);

% Visualize the volatility
figure;

% Plot for first variable
subplot(3,1,1);
plot(volatilityVar1, 'LineWidth', 1.5);
title('Volatility Analysis for First Variable');
xlabel('Time');
ylabel('Rolling Standard Deviation');
grid on;

% Plot for second variable
subplot(3,1,2);
plot(volatilityVar2, 'LineWidth', 1.5);
title('Volatility Analysis for Second Variable');
xlabel('Time');
ylabel('Rolling Standard Deviation');
grid on;

% Plot for third variable
subplot(3,1,3);
plot(volatilityVar3, 'LineWidth', 1.5);
title('Volatility Analysis for Third Variable');
xlabel('Time');
ylabel('Rolling Standard Deviation');
grid on;

% % decomposition analysis
% % Assuming your dataMatrix has time-series data for three variables
% 
% % Decompose the first variable
% ts1 = timeseries(corrMatrix(:,1));
% decomposed1 = decompose(ts1);
% 
% % Decompose the second variable
% ts2 = timeseries(corrMatrix(:,2));
% decomposed2 = decompose(ts2);
% 
% % Decompose the third variable
% ts3 = timeseries(corrMatrix(:,3));
% decomposed3 = decompose(ts3);
% 
% % Plotting the decompositions
% figure;
% 
% % Decomposition plots for the first variable
% subplot(3,3,1);
% plot(decomposed1.Trend);
% title('Trend for First Variable');
% 
% subplot(3,3,2);
% plot(decomposed1.Seasonal);
% title('Seasonality for First Variable');
% 
% subplot(3,3,3);
% plot(decomposed1.Irregular);
% title('Residuals for First Variable');
% 
% % Decomposition plots for the second variable
% subplot(3,3,4);
% plot(decomposed2.Trend);
% title('Trend for Second Variable');
% 
% subplot(3,3,5);
% plot(decomposed2.Seasonal);
% title('Seasonality for Second Variable');
% 
% subplot(3,3,6);
% plot(decomposed2.Irregular);
% title('Residuals for Second Variable');
% 
% % Decomposition plots for the third variable
% subplot(3,3,7);
% plot(decomposed3.Trend);
% title('Trend for Third Variable');
% 
% subplot(3,3,8);
% plot(decomposed3.Seasonal);
% title('Seasonality for Third Variable');
% 
% subplot(3,3,9);
% plot(decomposed3.Irregular);
% title('Residuals for Third Variable');

%cross correlation
% Cross-correlation between Variable 1 and Variable 2
[crossCorr_12, lags_12] = xcorr(corrMatrix(:,1), corrMatrix(:,2), 'coeff');

% Cross-correlation between Variable 1 and Variable 3
[crossCorr_13, lags_13] = xcorr(corrMatrix(:,1), corrMatrix(:,3), 'coeff');

% Cross-correlation between Variable 2 and Variable 3
[crossCorr_23, lags_23] = xcorr(corrMatrix(:,2), corrMatrix(:,3), 'coeff');


figure;

% Plot for Variable 1 and Variable 2
subplot(3,1,1);
plot(lags_12, crossCorr_12, 'LineWidth', 1.5);
title('Cross-Correlation between Variable 1 and Variable 2');
xlabel('Lags');
ylabel('Cross-Correlation');
grid on;

% Plot for Variable 1 and Variable 3
subplot(3,1,2);
plot(lags_13, crossCorr_13, 'LineWidth', 1.5);
title('Cross-Correlation between Variable 1 and Variable 3');
xlabel('Lags');
ylabel('Cross-Correlation');
grid on;

% Plot for Variable 2 and Variable 3
subplot(3,1,3);
plot(lags_23, crossCorr_23, 'LineWidth', 1.5);
title('Cross-Correlation between Variable 2 and Variable 3');
xlabel('Lags');
ylabel('Cross-Correlation');
grid on;


