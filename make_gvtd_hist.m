function thresh = make_gvtd_hist(gvtdTimeTrace, plotThresh, threshType,...
    nStd, binSize)

% Description:
%
% This function plots a GVTD histogram as well as its motion threshold
% based on find_gvtd_thresh(gvtdTt, StatType.Histogram_Mode, nStd)
% default values.
%
%  Inputs:
%     gvtdTimeTrace = GVTD time trace (assumes gvtdTt is a 1*n array)
%
%     nStd = number of left standard deviation for the GVTD motion
%     threshold (if any statType besides "Default" is chosen.
%
%     binSize = Size of histogram bin. The default value is 0.000035
%
%     plotThresh = the option for plotting the gvtd threshold on the plot

% Outputs:
%    GVTD histogram plot
%    thresh = GVTD threshold

% Author: Arefeh Sherafati (sherafati.arefeh@gmail.com)

if isempty(plotThresh), plotThresh = 1; end
if isempty(threshType), plotThresh = 1; end

if isempty(binSize)
    
    minCountsEachBin = 5;
    
    % Number of bins is defined based on the length of the recorded
    % data and the number of counts in each bin:
    nBins = round(size(gvtdTimeTrace, 1) / minCountsEachBin);
    
    % Bin size (del) is defined based on the maximum value of GVTD in
    % each run and the number of bins:
    binSize = max(gvtdTimeTrace(:)) / nBins;
    
end

figure;
histogram (gvtdTimeTrace, 'BinEdges', 0:binSize:max(gvtdTimeTrace(:)));

if plotThresh
    
    if isempty(nStd), nStd = 4; end

    thresh = find_gvtd_thresh(gvtdTimeTrace, threshType, nStd);

    hold on;
    [N, ~] = histcounts(gvtdTimeTrace);
    b = max(N);
    plot([thresh thresh] , [0 b]);

end
title('GVTD Histogram')
xlabel('GVTD');
ylabel('Counts')
