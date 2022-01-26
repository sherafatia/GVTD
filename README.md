# GVTD
Global Variance of Temporal Derivatives (GVTD) is a motion detection metric for multi-channel imaging techniques inspired by the DVARS metric in fMRI.

This repository contains code for calculating and optimizing GVTD-based motion tracking for High-Density Diffuse Optical Tomography (HD-DOT) introduced in the follwoing paper:

> Sherafati A, Snyder AZ, Eggebrecht AT, Bergonzi KM, Burns-Yocum TM, Lugar HM, Ferradal SL, Robichaux-Viehoever A, Smyser CD, Palanca BJ, Hershey T, Culver JP. Global motion detection and censoring in high-density diffuse optical tomography. Human Brain Mapping. July 2020 https://onlinelibrary.wiley.com/doi/abs/10.1002/hbm.25111

# Usage
`gvtd` calculates the GVTD time-trace of your data matrix (measurements by time)
#### Example:

    gvtdTimeTrace = gvtd(dataMatrix)

`find_gvtd_thresh` finds the GVTD censoring threshold based on different methods.
Dependencies: `StatType`
`StatType` is an enumeration that provides all possible options for calculating the GVTD threshold. `StatType.Histogram_Mode` was used in the original paper.

#### Example:
      
    statType = StatType.Histogram_Mode;
    nStd = 3;
    thresh = find_gvtd_thresh(gvtdTimeTrace, statType, nStd)

`make_gvtd_hist` plots a GVTD histogram as well as the motion threshold based on `find_gvtd_thresh`.

    thresh = make_gvtd_hist(gvtdTimeTrace, plotThresh, statType, nStd, binSize)
#### Example:

    statType = StatType.Histogram_Mode;
    nStd = 3;
    thresh = make_gvtd_hist(gvtdTimeTrace, '', statType, nStd, '')

License
----

Apache
