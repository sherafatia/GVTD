function thresh = find_gvtd_thresh(gvtdTimeTrace, statType, nStd)
% Description:
%
% This function finds the GVTD censoring threshold based on the mean, mode,
% median, MAD, and the left std ("left std" is the std of all the 
% time-points below the mode). 
%
% Dependencies: StatType
% StatType is an enumeration that provides all possible options for
% calculating the GVTD threshold. "StatType.Histogram_Mode" was used in 
% the Original paper.
%
%  Inputs:
%     gvtdTimeTrace = GVTD time-trace (assumes gvtdTimeTrace is a 1*n or
%     n*1 array)
%
%     statType = which statistic of the GVTD time trace you want to use for
%                setting the threshold. statType is a member of the StatType
%                enumeration. Default statType is mode plus the distance
%                between the samllest GVTD value and mode.
%
%     nStd = how many standard deviations above the statistic of interest
%               do you want to set your threshold, if not set, default
%               is 10 (smaller than 10 more stringent, range between
%               ~3-20). This varable is needed for all "statType"s except 
%               Default.
%
% Output:
%     thresh = GVTD motion detection threshold

% Author: Arefeh Sherafati (sherafati.arefeh@gmail.com)
% This function is in progress. In case of any errors or suggestions
% please email me.

%% Make sure GVTD is a row vector
if size(gvtdTimeTrace, 2) == 1
    gvtdTimeTrace = gvtdTimeTrace';
end

%% The default conditions
if nargin < 2
    statType = StatType.Default;
end

if (statType ~= StatType.Default) && (~exist('numStd', 'var')) 
    nStd = 10;
end

%% 
switch statType
    
    case StatType.Default
         % For making the histogram of the GVTD values, we chose to have at
        % 5 counts in each bin (minCountsEachBin): 
        minCountsEachBin = 5; 
        
        % Number of bins is defined based on the length of the recorded
        % data and the number of counts in each bin:
        nBins = round(size(gvtdTimeTrace, 2) / minCountsEachBin);
        
        % Bin size (del) is defined based on the maximum value of GVTD in
        % each run and the number of bins:
        del = max(gvtdTimeTrace(:)) / nBins; 
        
        % Hiscounts is used for finding the bin centers and the edges
        [N, edges] = histcounts (gvtdTimeTrace, 'BinWidth', del);
        
        % Mode of the histogram is defined as the (left) edge of the bin
        % with maximum value plus half bin size (to find the center on the
        % bin with maximum value):
        [~, argmax] = max(N);
        runMode = edges(argmax) + del/2;

        % To find the motion threshold, the distance between the
        % smallest GVTD value and the mode is calculated. Left tail is used, 
        % as it is dominated by the physiological signal and not
        % motion artifacts.
        
        minValToModeDist = runMode - min(gvtdTimeTrace(:));
        
        % Motion threshold is defined as mode plus a multiplier
        % of the standard deviation of the data-points below the mode
        thresh = runMode + minValToModeDist;
    
    case StatType.Histogram_Mode
        
        % For making the histogram of the GVTD values, we chose to have at
        % 5 counts in each bin (minCountsEachBin): 
        minCountsEachBin = 5; 
        
        % Number of bins is defined based on the length of the recorded
        % data and the number of counts in each bin:
        nBins = round(size(gvtdTimeTrace, 2) / minCountsEachBin);
        
        % Bin size (del) is defined based on the maximum value of GVTD in
        % each run and the number of bins:
        del = max(gvtdTimeTrace(:)) / nBins; 
        
        % Hiscounts is used for finding the bin centers and the edges
        [N, edges] = histcounts (gvtdTimeTrace, 'BinWidth', del);
        
        % Mode of the histogram is defined as the (left) edge of the bin
        % with maximum value plus half bin size (to find the center on the
        % bin with maximum value):
        [~, argmax] = max(N);
        runMode = edges(argmax) + del/2;

        % To find the motion criterion, the standard deviation of the
        % time-points on the left side of the mode is calculated. Left tail
        % is used, as it is dominated by the physiological signal and not
        % motion artifacts.
        numPointsBelowMode = size(gvtdTimeTrace (gvtdTimeTrace < runMode), 2);
        rmsPointBelowMode = sum((gvtdTimeTrace (gvtdTimeTrace < runMode) - runMode).^2);
        leftStdRun = sqrt(rmsPointBelowMode / numPointsBelowMode);
        
        % Motion threshold is defined as mode plus a multiplier
        % of the standard deviation of the data-points below the mode
        thresh = runMode + nStd * leftStdRun;
        
    case StatType.Kdensity_Mode
        
        % GVTD is skewed when there is noise and its pdf is close to
        % log-normal or chi distribution. Therefore for using the
        % kdensity estimation (MATLAB's kdensity default assumption chooses
        % the smoothing bandwidth with the normal distribution assumption).
        % We find the log of the gvtd time-course for finding the mode of 
        % the gvtd distribution.
        
        [f, xi] = ksdensity(log(gvtdTimeTrace));
        [~, I] = max(f);
        runMode = exp(xi(I));
               
        numPointsBelowMode = size(gvtdTimeTrace (gvtdTimeTrace < runMode), 2);
        rmsPointBelowMode = sum((gvtdTimeTrace (gvtdTimeTrace < runMode) -...
            runMode) .^ 2);
        
        leftStdRun = sqrt(rmsPointBelowMode / numPointsBelowMode);
        
        thresh = runMode + nStd * leftStdRun;
        
%   case StatType.Normalized_GVTD
        
    case StatType.Parabolic_Mode  
        
        % To approximate the bin with maximum value (mode), we can
        % use parabolic interpolation to better estimate the mode. Because
        % the bin with maximum value will change based on the binning. 
        % This method is suggested by Abraham Z. Snyder

        minCountsEachBin = 5; 
        nBins = round(size(gvtdTimeTrace, 2) / minCountsEachBin);
        del = max(gvtdTimeTrace(:)) / nBins;         
        
        [N, edges] = histcounts (gvtdTimeTrace, 'BinWidth', del);
        [~, argmax] = max(N);        
        
        centers = edges + del/2;
        centers = centers(1:end -1);
        x1 = centers(argmax-1); y1 = N(argmax-1);
        x2 = centers(argmax); y2 = N(argmax);
        x3 = centers(argmax+1); y3 = N(argmax+1);
        
        num = (x2^2 - x1^2) * (y2 - y3) - (x2^2 - x3^2) * (y2 - y1);
        denom = (x2 - x1) * (y2 - y3) - (x2 - x3) * (y2 - y1);
        runMode = (1/2) * (num / denom);
             
        numPointsBelowMode = size(gvtdTimeTrace (gvtdTimeTrace < runMode), 2);
        rmsPointBelowMode = sum((gvtdTimeTrace (gvtdTimeTrace < runMode) - runMode).^2);
        
        leftStdRun = sqrt(rmsPointBelowMode / numPointsBelowMode);        
        thresh = runMode + nStd * leftStdRun;  
      
    % For the next two cases, the same idea (stat + n left std) is used 
    % but instead of mode, mean and median are used (not recommended,
    % becasue those stats are more sensitive to outliers)
    case StatType.Mean
        runMean = mean(gvtdTimeTrace(:));
        
        numPointsBelowMode = size(gvtdTimeTrace (gvtdTimeTrace < runMean), 2);
        rmsPointBelowMode = sum((gvtdTimeTrace (gvtdTimeTrace < runMean) - runMean).^2);
        leftStdRun = sqrt(rmsPointBelowMode / numPointsBelowMode);
        
        thresh = runMean + nStd * leftStdRun;
        
    case StatType.Median
        runMedian = median(gvtdTimeTrace);

        numPointsBelowMode = size(gvtdTimeTrace (gvtdTimeTrace < runMedian), 2);
        rmsPointBelowMode = sum((gvtdTimeTrace (gvtdTimeTrace < runMedian) - runMedian).^2);
        leftStdRun = sqrt(rmsPointBelowMode / numPointsBelowMode);
        
        thresh = runMedian + nStd * leftStdRun;
    
    % In this case the threshold is calculated based on a constant times the
    % median absolute deviation of the GVTD histogram.
    case StatType.MAD
        runMad = mad(gvtdTimeTrace, 1);
        thresh = nStd * runMad;
    otherwise
        error('Unknown stat "%s"', StatType);
end

% Revision History:
%{
2018-05-03
 A. Sherafati modified binSize from 1e-7 to 1e-20.
2018-06-22
 A. Sherafati modified find_gvtd_threshold to calculate the left std based
 on each statistic, instead of only 'mode'.
2018-09-18
 A. Sherafati added the 'mode' calculation based on the parabolic
interpolation (Avi's method). 
2018-12-1
 A. Sherafati automated the binsize calculation. 
2019-2-15
 A. Sherafati modified the std for Mean and Median cases to be the left
 standard deviation similar to other cases.
2019-7-11
A. Sherafati added a condition for transposing the coloumn vector or a row
vector.
2019-11-18
A. Sherafati added a case "Default" that calculates the threshold based on
mode + the distance between the minimum GVTD value and the mode.
%}
