# GVTD
Global Variance of Temporal Derivatives (GVTD) is a motion detection metric for multi-channel Imaging techniques inspired by the DVARS metric in fMRI.

This repository contains code for calculating and optimizing GVTD-based motion tracking for High-density Diffuse Optical Tomography (HD-DOT) introduced in the follwoing preprint and Conference presentations:

> Sherafati A, Snyder AZ, Eggebrecht AT, Bergonzi KM, Burns-Yocum TM, Lugar HM, Ferradal SL, Robichaux-Viehoever A, Smyser CD, Palanca BJ, Hershey T, Culver JP. Global motion detection and censoring in High-density diffuse optical tomography. bioRxiv, Cold Spring Harbor Laboratory, March 2020 https://www.biorxiv.org/content/10.1101/2020.02.22.961219v1

> Sherafati A, Eggebrecht AT, Bergonzi KM, Burns-Yocum TM, Culver JP. Automated motion artifact detection and censoring in optical neuroimaging data. Neural Imaging and Sensing, SPIE Photonics West, Feb. 2019.

> Sherafati A, Eggebrecht AT, Bergonzi KM, Burns-Yocum TM, Culver JP. Improvements in functional diffuse optical tomography maps by global motion censoring techniques. Optics and the Brain, April 2018. JW3A. 51. https://www.osapublishing.org/abstract.cfm?uri=brain-2018-JW3A.51

> Sherafati A, Eggebrecht AT, Burns-Yocum TM, Culver JP. A global metric to detect motion artifacts in optical neuroimaging data. Neural Imaging and Sensing, SPIE Photonics West, Feb. 2017. https://www.spiedigitallibrary.org/conference-proceedings-of-spie/10051/1005112/A-global-metric-to-detect-motion-artifacts-in-optical-neuroimaging/10.1117/12.2252417.short?SSO=1

> Sherafati A, Eggebrecht AT, Burns-Yocum TM, Culver JP. A novel global metric to detect motion artifacts in optical neuroimaging data. fNIRS Conference, Oct. 2016.

# Usage
> gvtd.m calculates the GVTD time-trace of your data matrix (measurements by time)

GVTD = gvtd(dataMatrix)

> find_gvtd_thresh.m finds the GVTD censoring threshold based on different methods.
Dependencies: StatType
StatType is an enumeration that provides all possible options for calculating the GVTD threshold. "StatType.Histogram_Mode" was used in the original paper.

Example:
statType = 'StatType.Histogram_Mode';
nStd = 3;
thresh = find_gvtd_thresh(gvtdTimeTrace, statType, nStd)

> make_gvtd_hist.m plots a GVTD histogram as well as the motion threshold based on find_gvtd_thresh.m

thresh = make_gvtd_hist(gvtdTimeTrace, plotThresh, statType, nStd, binSize)
Example:
statType = 'StatType.Histogram_Mode';
nStd = 3;
thresh = make_gvtd_hist(gvtdTimeTrace, '', statType, nStd, '')

License
----

Apache
