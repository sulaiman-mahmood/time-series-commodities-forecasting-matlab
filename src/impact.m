datatable1=data1;
datatable1.Date = datetime(datatable1.Date, 'InputFormat', 'dd-MMM-yyyy');

%start and end dates of COVID-19 and Russia-Ukraine war periods
covidStart = datetime('01-Jan-2020', 'InputFormat', 'dd-MMM-yyyy'); % start date for COVID-19
covidEnd = datetime('01-Jan-2022', 'InputFormat', 'dd-MMM-yyyy');   % end date for COVID-19
warStart = datetime('01-Mar-2022', 'InputFormat', 'dd-MMM-yyyy');   % Start date of Russia-Ukraine war


% Plot commodity prices
figure;
hold on;
commodities = {'EnergyTransitionMetalIndex',
    'WheatNo1HardRedWinterOrdinaryProteinKansasCityUSPerMetricTon', 
    'CrudeOilpetroleumPriceIndex2016100SimpleAverageOfThreeSpotPric1', 
    'NaturalGasNetherlandsTTFNaturalGasForwardDayAheadUSPerMillionMe', 
    'GoldFixingCommitteeOfTheLondonBullionMarketAssociationLondon3PM'
    };
for i = 1:length(commodities)
        plot(data.Date, datatable1.(commodities{i}), 'DisplayName', commodities{i});
end

% Get the maximum and minimum Y values across all commodities for filling
maxY = max(max(datatable1{:, commodities}));
minY = min(min(datatable1{:, commodities}));

% Highlight COVID-19 period
fill([covidStart, covidEnd, covidEnd, covidStart], ...
     [minY, minY, maxY, maxY], ...
     'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');

% Highlight Russia-Ukraine war period
fill([warStart, max(datatable1.Date), max(datatable1.Date), warStart], ...
     [minY, minY, maxY, maxY], ...
     'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');

title('Commodity Prices Over Time with Impact Periods');
xlabel('Date');
ylabel('Price');
legend('show', 'Location', 'northwest');
grid on;
hold off;
