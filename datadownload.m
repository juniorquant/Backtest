%% rsMF
% Download data for the following symbols
tic;
startdate = '2000-01-01';
%directory = 'Data\Yahoo\';
directory = 'Data\MomF\Live\';
yahoodl('EWZ', directory, startdate, 2);
yahoodl('FXI', directory, startdate, 2);
yahoodl('IEF', directory, startdate, 2);
yahoodl('IYR', directory, startdate, 2);
yahoodl('SLV', directory, startdate, 2);
yahoodl('SPY', directory, startdate, 2);
yahoodl('TLT', directory, startdate, 2);
yahoodl('UNG', directory, startdate, 2);
yahoodl('USO', directory, startdate, 2);
toc;

