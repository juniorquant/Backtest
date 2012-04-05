classdef summary
    % Create summary for time series of signals and closes/returns
    
    properties
        folio
        pnlperperiod
        returnperperiod
        ec
        pnl
        mdd
        sharperatio
        dollarposition
    end
    
    methods
        % Constructor
        function s = summary(signals, fts, pointvalues, type)
            % Returns
            returns = (fts - lagts(fts, 1)) ./ lagts(fts, 1);
            returnsperperiod = sum(signals(1:end-1,:) .* fts2mat(returns(2:end)), 2);
            ftsreturns = tomonthly(fints(returns.dates(2:end), returnsperperiod, 'Returns'));
            % Calculation type
            switch type
                case 'Diff'
                    diffs = fts - lagts(fts, 1);
                    s.pnlperperiod = signals(1:end-1,:) .* fts2mat(diffs(2:end)) .* repmat(pointvalues, size(diffs(2:end), 1), 1);
                    s.folio = fints(diffs.dates(2:end), cumsum(s.pnlperperiod), fieldnames(fts, 1));
                    s.ec = fints(diffs.dates(2:end), sum(cumsum(s.pnlperperiod), 2), 'EC');
                case 'Return'
                    returns = (fts - lagts(fts, 1)) ./ lagts(fts, 1);
                    s.returnperperiod = signals(1:end-1,:) .* fts2mat(returns(2:end));
                    s.returnperperiod(isnan(s.returnperperiod)) = 0;
                    s.folio = fints(returns.dates(2:end), 1+cumsum(s.returnperperiod), fieldnames(fts, 1));
                    s.ec = fints(returns.dates(2:end), cumprod(1+sum(s.returnperperiod, 2)), 'EC');
            end
            % Dollar position
            dollarpos = abs(signals) .* fts2mat(fts) .* repmat(pointvalues, size(fts, 1), 1);
            s.dollarposition = fints(fts.dates, sum(dollarpos, 2));
            % PnL & MaxDD
            s.pnl = fts2mat(s.ec(end));
            s.mdd = maxdd(fts2mat(s.ec));
            % Sharpe ratio
            % TODO: Check Sharpe ratio calculations!
            s.sharperatio = sharpe(fts2mat(ftsreturns), 0.01);
            % Display
            s.display();
        end
        
        function a = annual(s)
            fts = fints(s.ec.dates, sum(s.pnlperperiod, 2));
            a = toannual(fts, 'CalcMethod', 'CumSum');
        end
        
        function m = monthly(s)
            fts = fints(s.ec.dates, sum(s.pnlperperiod, 2));
            m = tomonthly(fts, 'CalcMethod', 'CumSum');
        end
        
        % Heatmp function of pnls
        function heatmap(s)
            % Labels
            months = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', ...
                        'October', 'November', 'December', 'Totals'};
            years = s.annual();
            years = cellstr(datestr(years.dates, 'yyyy'))';
            % Fill hData
            mData = s.monthly();
            hData = zeros(length(years), length(months));
            for i=1:length(mData)
                row = strncmp(datestr(mData.dates(i), 'yyyy'), years, 4);
                column =  strncmp(datestr(mData.dates(i), 'mmmm'), months, 20);
            	hData(row, column) = fts2mat(mData(i));
            end
            hData(:, 13) = sum(hData, 2);
            heatmap(hData, months, years, '%0.0f', 'TickAngle', 90, 'GridLines', ':', ...
                     'Colormap', 'money', 'ColorLevels', 20, 'ShowAllTicks', true);
        end
        
        % Plot EC, all symbols EC, heatmap
        function plot(s)
            subplot(2,2,1);
            plot(s.folio);
            legend('Location', 'NorthWest');
            legend('boxoff');
            subplot(2,2,2);
            plot(s.ec);
            title([' PnL: ' num2str(s.pnl) ', MaxDD: ' num2str(s.mdd)]);
            legend('Location', 'NorthWest');
            legend('boxoff');
            subplot(2,2,3);
            s.heatmap();
            subplot(2,2,4);
            plot(s.dollarposition);
            legend('Location', 'NorthWest', 'Dollar Position');
            legend('boxoff');
        end
        
        % Display
        function display(s)
            %disp([' PnL: ' num2str(s.pnl) ', MaxDD: ' num2str(s.mdd)  ', Sharpe: ' num2str(s.sharperatio) ])
            disp([num2str(s.pnl) ' ' num2str(s.mdd) ' ' num2str(s.sharperatio) ])
        end
    end
end

