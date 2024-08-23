# Traveling to a City in The Land of a Thousand Hills
The link to the visualization is [here](https://kimminah.shinyapps.io/traveling_in_rwanda/).

## Executive Summary
This visualization demonstrates the complicated relationship between the distance and the traveling time to the nearest city in Rwanda. Traveling time to the city is significant since reducing traveling time can increase the market participation of Rwandan people and improve the income level of Rwandan families. Using the Advancing Research on Nutrition and Agriculture GIS-DHS data set by the International Food Policy Research Institute, this website shows that it may take longer to travel to the city than one may expect from the distance because of various factors. It briefly discusses how the high altitude and the mountainous terrain can lag the travel time and encourages researchers to conduct further research on the topic.

## About the Project
### Context of the Project
How does food arrive on our table? In the world of globalization, food often travels across the globe through multiple transactions among intermediaries. For the food produced by small farmers, they first travel with the farmers to the city to be in the market. However, traveling to a city is not free. The longer it takes for the farmers to travel, the higher the travel cost. In addition, the higher the cost of traveling, the lower the price competitiveness in the market, as the farmer needs to sell at a higher price to cover the travel expenses. The same applies to the buyers. If you have to travel long distances to buy crops from the market, it may be cheaper for them to cultivate the crop by themselves. As a result, the time of traveling to the nearest city is a factor of interest to policymakers who work with smallholder farmers.
    
In 2020, more than 76% of the Rwandan population depended on subsistence farming as a major source of income ([Weatherspoon et al., 2021](https://www.degruyter.com/document/doi/10.1515/jafio-2021-0011/html)). In other words, 76% of Rwandans farm to self-feed themselves rather than get involved in the food market. Although self-sustainable farming can be resilient to external shock, it usually produces less profit than selling the same product in the food market. When you glimpse the map of Rwanda, you may think that transportation is not a great hurdle in participating in the food market since it is a small country where you can easily travel from one end of a country to another in a day. However, Rwanda is called **the land of a thousand hills**. This mountainous country has an elevation that ranges from 1000m to 4500m ([U.S. Embassy in Rwanda](https://rw.usembassy.gov/embassy/kigali/agencies-offices/geography/)). These hills could be one of the many reasons that transportation time between the two points may not be proportional to the distance on the map in Rwanda.
  
This data visualization illustrates the relationship between the distance to the nearest city and the time it takes for the people to travel to the nearest city using the 2015 Advancing Research on Nutrition and Agriculture(AreNA) data from IFPRI. For researchers who have never worked with Rwanda before, it aims to provide the initial overview of the complicated relationship between the travel time and the distance in Rwanda. 

### The Intended Audience of the project
The audience of this project is the researchers who are unfamiliar to the geography in Rwanda yet wants to have a basic understanding of the remoteness in Rwanda. I expect the audience to comprehend in reading basic graphs, but I did not think they have a deep knowledge in Rwanda. In fact, this visualization should work only as an overview of the geography and help them imagine the human interactions on this land to ignite questions. 

### The Data Source
All the data comes from the [AreNA's DHS-GIS Database](https://www.ifpri.org/publication/arenas-dhs-gis-database) by the International Food Policy Research Institute (IFPRI). The data is under the Creative Commons Attribution 4.0 International, which allows to "reuse, distribute, and reproduce content even for commercial purposes" under the condition to "contain attribution of the content to IFPRI and any named authors of the dataset". You can read the full Term of Use from the [IFPRI Dataverse website that hosts the dataset](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/OQIPRW). 
  
Although the AreNA (Advancing Research on Nutrition and Agriculture) DHS-GIS dataset includes DHS (Demographic and Health Surveys) data, I only used the GIS portion of the data from this dataset. However, the GIS data of this data set are also collected during the DHS surveys, which are nationwide surveys that happen across 90 countries. Then, the GIS data were aggregated into cluster levels with some manipulation to hide the precise location. The locations were jittered around 0-2km for the urban population and around 0-5km (or rarely 0-10km) for the rural population. The resolution of the GIS data ranges from 250m to 50km. As a result, one should be cautious of the confidence interval while plotting the dot on the map. 
  
Furthermore, the only data that describe the population of the cluster is the population density variables. However, it does not describe the total area of the cluster, preventing to estimate the total population represented by the cluster. The data set also does not describe any demographic information (e.g. gender, age, occupation, etc.) of the cluster. As a result, the reader should be aware that each point does not represent the same group of people. 
  
The AreNA data set includes multiple years of surveys, but I filtered the data to those only collected in 2015 in Rwanda. This process left the dataset with 492 rows. I attempted to remove data that had missing GIS data, but there was no missing data.
 
- All regions (in the second administration level) have 16 clusters, except Gasabo, Kicukiro, and Nyarugenge. These three regions are urban areas around the capital city Kigali and have 20 clusters represented in the data. 
- The longitude and the latitude of the AreNA data each range from 28.891085 to 30.842081 and from -2.801089 to -1.106774.
- When the cluster is noted as "Urban",  I use the urban population density. When it says it is "Rural", I use the rural population density. However, there are cases when the urban population density is recorded as 0. In those cases, I suppliment it with the rural population density data. 
- In this visualization, the user can alter the definition of the nearest city by changing the threshold for the local population. The dataset provides data for the distance and travel time for the city with a population of more than 20,000, 50,000, 100,000, 250,000, and 500,000 people.

Here are the summary statistis of **distance** from city based on each population in minutes.
|        | more than 20k | more than 50k | more than 100k | more than 250k | more than 500k |
|--------|---------------|---------------|----------------|----------------|----------------|
| Min.   | 0.004         | 0.004         | 0.004          | 0.004          | 2.581          |
| 1st Qu.| 0.140         | 0.212         | 0.212          | 0.252          | 3.287          |
| Median | 0.239         | 0.387         | 0.387          | 0.463          | 3.499          |
| Mean   | 0.258         | 0.369         | 0.378          | 0.437          | 3.599          |
| 3rd Qu.| 0.355         | 0.521         | 0.533          | 0.623          | 3.894          |
| Max.   | 0.755         | 0.755         | 0.943          | 0.942          | 4.713          |


Here are the summary statistics of **time travel** from city based on each population in kilometers.
  
|        | more than 20k | more than 50k | more than 100k | more than 250k | more than 500k |
|--------|---------------|---------------|----------------|----------------|----------------|
| Min.   | 11.37         | 11.37         | 11.37          | 11.37          | 492.1          |
| 1st Qu.| 102.34        | 150.38        | 150.38         | 160.01         | 715.8          |
| Median | 177.56        | 215.16        | 215.16         | 224.66         | 804.3          |
| Mean   | 197.74        | 230.79        | 232.26         | 239.40         | 813.7          |
| 3rd Qu.| 274.22        | 299.55        | 300.38         | 305.79         | 881.3          |
| Max.   | 684.92        | 761.49        | 761.49         | 761.49         | 1396.1         |



The shapefiles were the "Second-level Administrative Dvision, Rwanda, 2015" and "Fourth-level Administrative Dvision, Rwanda, 2015", produced by Robert J. Hijamans and the Museum of Vertebrate Zoology of the University of California, Berkeley. I fetch the two shapefiles from the Web Feature Services (WFS) distributed by Stanford University. The shapefiles are "freely available for academic use and other non-commercial use" and can be used "to create maps and use the data in other ways for publication in academic journals, books, reports, etc" ([Hijmans & University of California, Berkeley](https://earthworks.stanford.edu/catalog/stanford-qy869sx9298)).

### Technology / Platform
This product is written using the Rshiny package and hosted in shinyapps.io. In addition to tidyverse and ggplot2, it also uses the [sf](https://r-spatial.github.io/sf/) and the [geofacet](https://cran.r-project.org/web/packages/geofacet/vignettes/geofacet.html) package to visaulize geospatial data.

## Reference
Hijmans, R. J., University of California, Berkeley. Museum of Vertebrate Zoology. (n.d.) Second-level administrative divisions, Rwanda, 2015. Stanford EarthWork. Retrieved from https://earthworks.stanford.edu/catalog/stanford-qy869sx9298.

Hijmans, R. J., University of California, Berkeley. Museum of Vertebrate Zoology. (2015). Fourth-level Administrative Divisions, Rwanda, 2015. [Shapefile]. University of California, Berkeley. Museum of Vertebrate Zoology. Retrieved from https://earthworks.stanford.edu/catalog/stanford-kt081vp3812
  
Hijmans, R. J., University of California, Berkeley. Museum of Vertebrate Zoology. (2015). Second-level Administrative Divisions, Rwanda, 2015. [Shapefile]. University of California, Berkeley. Museum of Vertebrate Zoology. Retrieved from https://earthworks.stanford.edu/catalog/stanford-qy869sx9298

International Food Policy Research Institute (IFPRI). (2021, February 23). Arena’s DHS-Gis Database. Harvard Dataverse. https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910%2FDVN%2FOQIPRW 
  
International Food Policy Research Institute (IFPRI). (2020). AReNA’s DHS-GIS Database. Washington, DC: IFPRI [dataset]. https://doi.org/10.7910/DVN/OQIPRW. Harvard Dataverse. Version 1.
   
U.S. Embassy in Rwanda. (n.d.). Geography. Retrieved from https://rw.usembassy.gov/embassy/kigali/agencies-offices/geography/
  
Weatherspoon, D., Miller, S., Niyitanga, F., Weatherspoon, L. & Oehmke, J. (2021). Rwanda’s Commercialization of Smallholder Agriculture: Implications for Rural Food Production and Household Food Choices. Journal of Agricultural & Food Industrial Organization, 19(1), 51-62. https://doi.org/10.1515/jafio-2021-0011

