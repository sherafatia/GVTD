function gvtdTimeTrace = gvtd(dataMatrix)

% Description:
%
% This function calculates the GVTD time-trace of a data matrix of all 
% measurements by time.

% Global Variance of Temporal Derivatives (GVTD) is a motion detection 
% metric for multi-channel imaging techniques inspired by the DVARS metric
% in fMRI.
%
%  Input:
%     dataMatrix = The matrix of all measurements by time (#channels * time)

% Output:
%     gvtdTimeTrace = GVTD time-trace (time * 1)

% Author: Arefeh Sherafati (sherafati.arefeh@gmail.com)

% Step 1: Find the matrix of the temporal derivatives
dataDiff = dataMatrix-circshift(dataMatrix, [0 -1]);

% Step 2: Find the RMS across the channels for each time-point of dataDiff
gvtdTimeTrace = rms(dataDiff(:, 1:(end - 1)), 1)';

% Step 3: Add a zero in the beginning for GVTD to have the same number of
% time-points as your original dataMatrix
gvtdTimeTrace = cat(1, 0, gvtdTimeTrace);
