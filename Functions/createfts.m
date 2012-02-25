function [fts] = createfts(file, ohlc)

% Which of OHLC to use
switch ohlc
    case 'Open'
        column=2;
    case 'High'
        column=3;
    case 'Low'
        column=4;
    case 'Close'
        column=5;
    case 'Volume'
        column=6;
    case 'All'
        column=2:6;
end

% Import the file
raw = importdata(file);
% Create the dates vector
dates = datenum(num2str(raw(:,1)),'yyyymmdd');
% Decompose the name of the file to extract the name without the extension
[~, name, ~] = fileparts(file);
% create the time serie
if strcmp(ohlc, 'All')
    datanames = {'Open', 'High', 'Low', 'Close', 'Volume'};
    fts = fints(dates, raw(:,column), datanames, 'd');
else
    fts = fints(dates, raw(:,column), name, 'd');
end

end



