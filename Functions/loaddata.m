function [ data ] = loaddata( directory, universe )

% universe: Stock in the universe

    % Check if universe is populated
    if isempty(universe)
        files = dir(strcat(directory, '*.txt'));
    else
        files = universe;
    end

    % Initialize struct
    futures = struct('name', {}, 'pointvalue', {}, 'data', {}, 'dClose', {}, 'wClose', {}, 'mClose', {});
    futures(length(files)).name = '';
    % Go through all files
    % TODO: Check if directory is not empty
    firstdates = zeros(length(files), 1);
    lastdates = zeros(length(files), 1);
    for k=1:length(files)
        [~, name, ~] = fileparts(files(k).name);
        filename = [directory, name, '.txt'];
        
        % Check if file exists
        if exist(filename, 'file')
            futures(k).name = name;
            futures(k).data = createfts([directory, name, '.txt'], 'All');

            % Find start date
            datesbound = ftsbound(futures(k).data);
            firstdates(k) = datesbound(1);
            lastdates(k) = datesbound(2);
        else
            error('loaddata:symbol', strcat('The following symbol in the universe doesn''t have data: ', name));
        end
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

