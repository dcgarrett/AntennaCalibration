GRL Calibration for Biological Tissue Measurements
	David Garrett, 2015-2016
	davidchristophergarrett@gmail.com


This program performs GRL calibration, similarly to the method outlined in:
"Improved Free-Space S-Parameter Calibration" by P.G. Bartley and S.B. Begley

This is to be used for dielectric property estimation, particularly for use with the Nahanni antennas designed in the TSAR group at the University of Calgary.
Although it has not yet been validated for use with other antennas, the technique should ideally function with any antenna designed for tissue measurements.

Two calibration procedures are required:
Thru - Performed with the antennas directly in contact with one another
Reflect - Performed with a metallic surface separating the antennas, of minimal thickness

These procedures are then used to determine two correction matrices for the antennas, O and P. 
Using O and P, it is possible to remove the effect of the antennas on the measurement of the tissue.
This leaves the response solely due to the tissue, from which the dielectric properties can be estimated. 

This is done differently than was done in the original publication. 
The magnitude and phase of the calibrated transmission signal are used to estimate the complex propagation constant.
From this, permittivity and conductivity can be estimated.