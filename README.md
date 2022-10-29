# MATLAB parsing of raw Laser Spectrum Analyzer output
Code for analyzing data from the Laser Spectrum Analyzer (LSA) by High Finesse. The LSA outputs a raw text file in ASCII format. This code converts the text file to a MATLAB matrix.

The raw ASCII file will have a ```.ltx``` file format. When the ```.ltx``` file is converted to a raw text file, it will be millions of lines long. The following figure shows the structure of the text file. The yellow regions are populated with data, whereas the green regions are used as markers for the yellow regions. 

<img src="https://github.com/ncan33/matlabHighFinesse/blob/main/images/image1.png?raw=true" width="400">

A representative table of the yellow region is presented in the following figure. The matrix has a length of 5,382 for this acquisition. Acquisition length may vary in different trials.

<img src="https://github.com/ncan33/matlabHighFinesse/blob/main/images/image2.png?raw=true" width="400">

The following provides a visualization of the method of adding each yellow area together. Each frame was concatenated horizontally in a sequential manner. In the end, there was a Nx5382 matrix, where N is the number of frames.

<img src="https://github.com/ncan33/matlabHighFinesse/blob/main/images/image3.png?raw=true" width="500">

There is a problem with this matrix, however. The wavelength of each frame starts at a different value. For instance, in my data frame 1 and 2 started at 655.6745 nm and 655.6848 nm respectively. In order to overcome this problem, code was written to align the wavelength values of the matrix. First, the matrix was reassigned to an empty matrix with wavelength range 657 to 663 nm. The following figure effectively visualizes this algorithm (not to scale). The misaligned wavelengths are aligned.

<img src="https://github.com/ncan33/matlabHighFinesse/blob/main/images/image4.png?raw=true" width="450">

At this point, the data is organized and ready for analysis.
