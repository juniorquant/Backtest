function [ res ] = yahoodl( symbol, directory, startdate, nround )
% yahoodl: Fetch historic data from yahoo finance and adjust the data
% save data to the specified folder with NT format
% symbol: Yahoo symbol for the download
% directory: Directory where the data is to be saved
% nround: number of decimals after the point

% Start and end date - end date at today:
[sYear, sMonth, sDay, ~, ~, ~] = datevec(startdate);
[eYear, eMonth, eDay, ~, ~, ~] = datevec(now);

% URL for download
url_string = sprintf('http://ichart.finance.yahoo.com/table.csv?s=%s&a=%i&b=%i&c=%i&d=%i&e=%i&f=%i',...
    upper(symbol), sMonth-1, sDay, sYear, eMonth-1,eDay, eYear);
% Download data
data = urlread(url_string);
% Skip header
i = regexp(data,'\n','once');
% Parse data
raw = textscan(data(i+1:end), '%s %n %n %n %n %n %n','delimiter',',');

% Save data to vectors
dates = flipud(datenum(raw{1}));
open = flipud(raw{2});
high = flipud(raw{3});
low = flipud(raw{4});
close = flipud(raw{5});
volume = flipud(raw{6});
adj_close = flipud(raw{7});

% Adjust data
adj_coeff = adj_close ./ close;
open = roundn(open .* adj_coeff, -nround);
high = roundn(high .* adj_coeff, -nround);
low = roundn(low .* adj_coeff, -nround);
close = adj_close;
%volume = round(volume / 100 .* adj_coeff) * 100;

% Output file where the data needs to be saved
output = char(strcat(directory, symbol, '.txt'));
% Delete file if exists
if exist(output, 'file') 
    delete(output); 
end
% Save lines to the file
fid = fopen(output, 'a');
for i=1:length(dates)
    tline = strcat(datestr(dates(i), 'yyyymmdd'), ';', num2str(open(i)), ';', num2str(high(i)), ';', ...
            num2str(low(i)), ';', num2str(close(i)), ';', num2str(volume(i)), '\r\n');
    fprintf(fid, tline);
end
fclose(fid);

% End always return 1
res = 1;

end


    
