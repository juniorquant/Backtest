function [ data, symbols ] = readdata( directory, tofts )

    % Load data in a struct
    struct = loaddata(directory);
    
    % Merge all data
    fields = {'O', 'H', 'L', 'C', 'V'};
    nbfields = length(fields);
    m = length(struct(1).data);
    n = length(struct); % nb fields per symbol
    mat = zeros(m, n * nbfields);
    names = char(struct.name);
    fieldnames = [];
    for i=1:n
        fieldnames =[ fieldnames strcat(struct(i).name, fields) ];
        mat(1:m,((i-1)*nbfields+1):(i*nbfields)) = fts2mat(struct(i).data);
    end
   
    if tofts
        data = fints(struct(1).data.dates, mat, fieldnames);
    else
        data = mat;
    end
    symbols = names;
end
