function [ data, symbols ] = readdata( directory, universe, tofts )

    % Load data in a struct
    struct = loaddata(directory, universe);
    
    % Merge all data
    fields = {'O', 'H', 'L', 'C', 'V'};
    nbfields = length(fields);
    m = length(struct(1).data);
    n = length(universe); % number of symbols in the universe
    mat = zeros(m, n * nbfields);
    names = {universe.name};
    fieldnames = [];
    for i=1:n
        % Add to the matrix
        disp(struct(i).name);
        fieldnames =[ fieldnames strcat(struct(i).name, fields) ];
        %disp(struct(j).name);
        mat(1:m,((i-1)*nbfields+1):(i*nbfields)) = fts2mat(struct(i).data);
    end
   
    if tofts
        data = fints(struct(1).data.dates, mat, fieldnames);
    else
        data = mat;
    end
    symbols = names;
end
