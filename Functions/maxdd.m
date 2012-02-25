function [mdd] = maxdd(ec)
% Maximum drawdown is defined as the largest drop from a peak to a bottom
% experienced in a certain time period.
%
% [mdd] = maxdd(r)
%
% INPUTS:
% ec...      equity curve vector
%
% OUTPUTS:
% mdd...   Maximum drawdown expressed in currency

% size of r
n = max(size(ec));

% calculate drawdown vector
mx = 0;
dd = zeros(n, 1);
for i = 1:n
    if ec(i) > mx
        mx = ec(i); 
    end;
    dd(i) = mx - ec(i); 
end;

% calculate maximum drawdown statistics
mdd = max(dd);
