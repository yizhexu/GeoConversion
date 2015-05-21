<center><img src="https://raw.githubusercontent.com/yizhexu/GeoConversion/master/image/logo.png" alt="logo"></center>
<center><h2>Convert Georeferenced Data</h2></center>
<center><p> by <a href="http://www.awhere.com/services-and-support/professional-services" target="_blank">aWhere Professional Service</a></p><br></center>


Within the Dev aWhere <a href="http://apps.awhere.com/" target="_blank"><i>platform</i></a> every dataset is georeferenced using a standard geographic coordinate system.  A common location system allows for data to be integrated in a geographic environment, such as a map. For point level data, i.e., data with an x- and y-coordinate, the Dev aWhere platform requires latitude (x) and longitude (y) to be submitted in a standard format called decimal degrees. Decimal degrees expresses latitude and longitude as decimal fractions, and is an alternative to using degrees, minutes, seconds or UTM.


This app helps you:

<li><b>Convert a coordinate point (x,y) in degree, minute, second to decimal degrees and locate it on a map; </b></li>
<li><b>Convert a coordinate point (x,y) in UTM measures to decimal degrees and locate it on a map; </b></li>
<li><b>Convert a csv file with a set of coordinates point in degree, minute, second to decimal degrees and locate them on a map; </b></li>
<li><b>Convert a csv file with coordinate point in UTM measures to decimal degrees and locate them on a map. </b></li>

There are two Geographic coordinate system is one of the two common types of coordinate systems used in geographic information system (GIS), geographic coordinate systems (GCS) and projected coordinate systems.

A Ggeographic coordinate system is a global or spherical coordinate system. One method for describing a location within this system is using spherical measures of latitude and longitude.

<li><b>Longitude measures angles in an east–west direction and latitude measures angles in a south-north direction.</b></li>
<li><b>They are usually recorded in degree, minutes, and seconds.</b></li>
<li><b>Note: GPS coordinates stored as degrees, minutes, seconds must have a direction associated with them (i.e., North/South, East/West). If latitude is south, then latitude in decimal degrees will be negative (-). If longitude is west, then in longitude in decimal degrees will be negative (-).</b></li>

A Pprojected coordinate system is established based on a map projection such as Universal Transverse Mercator (UTM). Projected coordinate systems provide a mechanism to project a spherical surface onto a 2-dimensional plane.

<li><b>UTM divides the earth’s surface into 120 zones, based on location in the Northern Hemisphere or Southern Hemisphere.</b></li>
<li><b>Within each hemisphere, UTM coordinates are based on locations within 60 bands running north and south, each of width 6° of longitude.</b></li>
<li><b>Within each zone, location is represented by an Easting (x coordinate) and a Northing (y coordinate), each measured in meters. aWhere Professional Service is a map of UTM zones.</b></li>

<center><h3>App Screenshots</h3></center>
aWhere, Latitude is 39°55′30.9742″ N and Longitude is 105°06′16.3199″ W. The converted result shows the place on a map with latitude and longitude in decimal degrees as 39.9252706111111,-105.104533305556. 

<img src="https://raw.githubusercontent.com/yizhexu/GeoConversion/master/image/1.PNG" alt="Single Point">

You can also convert a bunch of points by downloading and re-uploading a data template. 

<img src="https://raw.githubusercontent.com/yizhexu/GeoConversion/master/image/2.PNG" alt="Multiple Point">

<center><h3>Data Requirement</h3></center>

The app can process data in the following follows the formats: 
<li>Single point data in degree, minute, second: This tool allows you to directly enter an individual coordinate in degrees, minutes, seconds and generate the equivalent decimal degrees for latitude and longitude.</li>
<li>Single point data in UTM: This tool allows you to specify the . Please specify Zone, Datum, and Easting value and Northing value for an individual point to generate the equivalent decimal degrees for latitude and longitude. </li>
<li>Batch coordinate data formatted as degrees, minutes, second. Please download the data template and copy paste degree, minute and second data as bare numbers into the related cells. The values for degrees, minutes, and seconds must be in separate columns before you copy and paste into the template. If you need help separating your data into separate columns in excel, please download – Converting GPS Coordinates to Decimal Degrees in Excel. <b>Don't change</b> the names of the columns in the template.</li>
<li>•	Batch UTM data. Please download the data template and copy paste easting and northing data as bare numbers into related cells. Make sure to select the Datum and Zones. <b>Don't change</b> the names of the columns in the template.</li>


<center><h3>Acknowledgement</h3></center>
    

Thanks to <a href="http://www.rstudio.com/" target="_blank">RStudio</a>'s <a href="http://rstudio.github.io/leaflet/" target="_blank">leaflet</a> package. R developers can leverage the power of JavaScripts libraries such as <a href="http://leafletjs.com/" target="_blank"><i>Leaflet</i></a> for making interactive maps in R. Also, the RStudio team has provided the community two very powerful tools: <a href="http://shiny.rstudio.com/" target="_blank"><i>Shiny</i></a> and <a href="https://www.shinyapps.io/" target="_blank"><i>ShinyApps</i></a>. 
These tools allow R users to quickly develop and to host web applications.

The <a href="http://cran.r-project.org/web/packages/markdown/index.html" target="_blank">Markdown</a> package maintained by <a href="http://yihui.name/en/" target="_blank"><i>Yihui Xie</i></a> helps building pages in Shiny much easier. 

<a href="http://cran.r-project.org/web/packages/rgdal/index.html" target="_blank"><i>rgdal</i></a> package by package by Roger Bivand streamlines many complex spatial data transforming procedures in R.

<center><h3>License</h3></center>

This app comes with the <a href="https://www.gnu.org/licenses/old-licenses/gpl-2.0.html" target="_blank"> GNU General Public License (GPL) version 2 (#GPLv2)</a>.
