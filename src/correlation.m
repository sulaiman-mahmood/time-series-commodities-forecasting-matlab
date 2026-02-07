data=data1;
corrMatrix = corr(data);

% Create a correlation plot using corrplot
corrplot(corrMatrix, 'type', 'scatter');
title('Correlation Plot');


% Calculate the correlation matrix
corrMatrix = corr(data.Date);

% Create a custom heatmap
figure;
h = heatmap(corrMatrix);
h.Title = 'Correlation Plot';