# IPEDS_Distance
This is an R Script that uses the latitude and longitude of institutions to determine the distance away from each other and a home institution.

The .csv files are the following:

IPEDS_Data.csv - This file contains the basic information about the institution including UnitID, Name, Address, Location, Level, Sector, etc which was downloaded from the IPEDS Data Center at https://nces.ed.gov/ipeds/Home/UseTheData.

IPEDS_ValueLabels.csv - This file is also from the IPEDS Data Center and contains the value labels for specified variables in the IPEDS_Data.csv file.

The R file is the script and the following lines will need to be changed for this to work on your computer with your institution.

Lines 5 and 6: If these packages are already installed, these lines can be commented out.

Line 12: Set this working directory to the location where you will store the IPEDS csv files above and the final spreadsheet will be written out.

Lines 22 and 23: Set the longitude and latitude for your institution here in order to compare it with all other institutions.

