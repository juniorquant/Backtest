%% Clear workspace
clear();

%% Parameters
D = 30;
J = 6;
S = 2;
risksize = 500000;
frequency = 'm';
directory = 'Data\';
pointvalues = [250 500 25000 50 33.2 125 2500 1000];
% Struct for Charts
ecs = struct('name', {}, 'EC', {}); 
ecs(length(J)*length(S)).name = '';

%% Read data
tic;
disp('Read Data');
[dRawData, symbols] = readdata( directory, 1 );
toc;

%% Loop
tic;
disp('Optimization');
for s=1:length(S)
    for j=1:length(J)
        % Backtest
        b = rsBAH(dRawData, symbols, pointvalues, risksize, D);
        % Chart
        ecs(length(J)*(s-1) + j).name = strcat('S', num2str(S(s)), 'J', num2str(J(j)));
        ecs(length(J)*(s-1) + j).EC = b.ec;
    end
end
toc;

%% Plot
plot(struct2mat(ecs, 'EC'));
