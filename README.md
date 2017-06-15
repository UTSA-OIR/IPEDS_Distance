# IPEDS_Distance
This is an R Script that uses the latitude and longitude of institutions to determine the distance away from each other and a home institution.

The .csv files which will need to be downloaded to your computer are the following:

**IPEDS_Data.csv** - This file contains the basic information about the institution including UnitID, Name, Address, Location, Level, Sector, etc which was downloaded from the IPEDS Data Center at https://nces.ed.gov/ipeds/Home/UseTheData.

**IPEDS_ValueLabels.csv** - This file is also from the IPEDS Data Center and contains the value labels for specified variables in the IPEDS_Data.csv file.


**mileconvert_all_institutions.R** - This R file is the script and the lines below will need to be changed for this to work on your computer with your institution.  Warning, this does take about 45 minutes to run.

    *Lines 5 and 6:* If these packages are not already installed, these lines can be uncommented to install the packages.

    *Line 12:* Set this working directory to the location where you will store the IPEDS csv files above and the final spreadsheet will be written out.

    *Line 19:* Set this number to the number of miles you want to look at.

    *Lines 31 and 32:* Set the longitude and latitude for your institution here in order to compare it with all other institutions in the file.
