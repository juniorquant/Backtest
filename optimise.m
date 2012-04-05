%% Clear workspace
clear();

%% Universe Selection
% Symbol,PointValue,Constraint
%universestring = {'EWZ,100,0', 'FXI,100,0', 'IEF,100,0', 'IYR,100,0', ...
%                    'SLV,100,0', 'SPY,100,0', 'TLT,100,0', 'UNG,100,0', 'USO,100,0'};
%universestring = {'EURUSD,10000,0', 'EWZ,100,0', 'FXI,100,0', 'IEF,100,0', 'IYR,100,0', ...
%                    'SLV,100,0', 'SPY,100,0', 'TLT,100,0', 'UNG,100,0', 'USO,100,0'};
universestring = {'EURUSD,10000,0', 'EWZ,100,0', 'FXI,100,0', 'IEF,100,0', 'IYR,100,0'};
universe = stringtouniverse(universestring);

%% Read data
tic;
disp('Read Data');
[dRawData, symbols] = readdata( 'Data\MomF\Live\', universe, 1 ); % Data\Yahoo\
toc;
save('MomentumFutures\rawfoliodata.mat');

%% Load data
load('MomentumFutures\rawfoliodata.mat');

%% Parameters
D = 30;
P1 = 6;
P2 = 2;
risksize = 100000;
frequency = 'm';
% Structure to hold optimization results
ecs = struct('name', {}, 'EC', {}, 'summary', {}, 'positions', {}); 
ecs(length(P1)*length(P2)).name = '';

%% Loop
tic;
disp('Optimization');
for i=1:length(P1)
    for j=1:length(P2)
        % Index
        idx = length(P2)*(i-1) + j;
        % Structure
        ecs(idx).name = strcat('P1', num2str(P1(i)), 'P2', num2str(P2(j)));
        %[ecs(idx).summary ecs(idx).positions ~] = rsMF(dRawData, symbols, [universe.pointvalue], [universe.constraint], frequency, risksize, D, P1(i), P2(j)); % J, Signal
        ecs(idx).summary = rsBAH(dRawData, symbols, [universe.pointvalue], risksize, D);
        %ecs(idx).summary = rsCTA(dRawData, symbols, [universe.pointvalue], P1(i), P2(j)); % MM1, MM2
        ecs(idx).EC = ecs(idx).summary.ec;
    end
end
toc;

%% Plot
plot(struct2mat(ecs, 'EC'));

%% Summary Plot
ecs.summary.plot();
