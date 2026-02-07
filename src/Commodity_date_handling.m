non_normalized_data=externaldatamay;
convertToDate = @(str) strrep(str, 'M', '0'); 
convertToDate1 = @(str) strcat(str(1:4), str(end-1:end), '01');
non_normalized_data.CommodityDescription = cellfun(convertToDate, non_normalized_data.CommodityDescription, 'UniformOutput', false);
non_normalized_data.CommodityDescription = cellfun(convertToDate1, non_normalized_data.CommodityDescription, 'UniformOutput', false);
non_normalized_data.CommodityDescription = datetime(non_normalized_data.CommodityDescription, 'InputFormat', 'yyyyMMdd'); 
% Display the updated data types

disp(class(non_normalized_data.CommodityDescription));
head(non_normalized_data,5);
head(non_normalized_data,5);