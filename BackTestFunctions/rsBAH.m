function [ s, positions, estimator ] = rsBAH( dRawData, symbols, contractsizes, risk, D )
% rsBAH: Buy and Hold Strategy
% dRawData: Data in fts
% symbols: List of symbols
% contractsizes: Contract sizes for the traded symbols
% frequency: Could be daily: 'd', weekly: 'w' or monthly: 'm'
% D: Loopback for the estimator

% Variables
const = risk * 0.1/sqrt(length(symbols));
fc = 4:5:size(dRawData, 2); % Closes fields

% Initializes matrices
dEstimator = zeros(size(dRawData, 1), length(symbols));
dPositions = zeros(size(dRawData, 1), length(symbols));

% Loop through data
for i=D+1:length(dRawData)
	% Volatility Estimator
	dEstimator(i, :) = estimatevolatility(fts2mat(dRawData(i-D:i)), D, 'YZ');
	% Signal
    data = fts2mat(dRawData(i));
    signals = ones(1, length(symbols));
    dollarvolatility = dEstimator(i, :) .* data(end, fc) .* contractsizes;
    maxsize = round(repmat(const, 1, length(symbols)) ./ dollarvolatility);
    % Positions
    dPositions(i, :) = maxsize .* signals;
end
% Summary
s = summary(dPositions, extfield(dRawData, cellstr(strcat(symbols, 'C'))), contractsizes, 'Diff');
positions = dPositions;
estimator = dEstimator;

end



