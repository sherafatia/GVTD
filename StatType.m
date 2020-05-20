% StatType enumeration is defined to provide all possible options for
% calculating the GVTD threshold with find_gvtd_thresh function

% Author: Arefeh Sherafati (sherafati.arefeh@gmail.com)

classdef StatType
    enumeration 
        Default, Histogram_Mode, Kdensity_Mode, Parabolic_Mode, Mean, Median, MAD
    end   
end