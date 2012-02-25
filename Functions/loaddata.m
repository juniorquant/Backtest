function [ data ] = loaddata( directory )

    % List directory
    files = dir([directory, strcat('*', '.txt')]);
    % Initialize struct
    futures = struct('name', {}, 'pointvalue', {}, 'data', {}, 'dClose', {}, 'wClose', {}, 'mClose', {});
    futures(length(files)).name = '';
    % Go through all files
    % TODO: Check if directory is not empty
    firstdates = zeros(length(files), 1);
    lastdates = zeros(length(files), 1);
    for k=1:length(files)
        [~, name, ~] = fileparts(files(k).name);
        futures(k).name = name;
        futures(k).data = createfts([directory, files(k).name], 'All');
        
        % Find start date
        datesbound = ftsbound(futures(k).data);
        firstdates(k) = datesbound(1);
        lastdates(k) = datesbound(2);
    end

    % Resize data, and align it
    mindate = datestr(max(firstdates));
    for k=1:length(files)
        % Daily data
        %display(k);
        futures(k).data = fetch(futures(k).data, mindate, [], datestr(lastdates(k)), [], 1, 'd');
        futures(k).data = todaily(futures(k).data, 'BusDays', 1, 'AltHolidays', -1);
        futures(k).data = fillts(futures(k).data, 'zero');
        futures(k).dClose = futures(k).data.Close;
        % Weekly data
        futures(k).wClose = toweekly(futures(k).data.Close, 'EOW', 5);
        % Monthly data
        futures(k).mClose = tomonthly(futures(k).data.Close);
    end

    data = futures;
end

