# Conflict in Africa from ACLED's Data

### An R shiny app to browse ACLED's conflict data (Africa Only)

#### Updates:
The current version of the app is deprecated due to problems with `ggmap`'s connections with various map-acquisition APIs. The current version under development (not posted yet) will (1) incorporate `leaflet` to make the maps and add much-needed browse-ability, and (2) will incorporate [Jeremy Allen](https://github.com/jeremy-allen/getACLED)'s `get_acled()` function to update the data in real-time rather than requiring me to update the data periodically by hand. 

The deployed version of this R Shiny application is available [here](https://acm9q.shinyapps.io/africanconflictapp/). 

Data last updated 4/27/18.

Download your copy of ACLED's data [here](https://www.acleddata.com/data/). The file is too large to upload directly to Github. 

## From ACLED:

ACLED (Armed Conflict Location & Event Data Project) is the most comprehensive public collection of political violence and protest data for developing states. This data and analysis project produces information on the specific dates and locations of political violence and protest, the types of event, the groups involved, fatalities, and changes in territorial control. Information is recorded on the battles, killings, riots, and recruitment activities of rebels, governments, militias, armed groups, protesters and civilians.

ACLED has recorded close to 200,000 individual events, with ongoing data collection focused on Africa and ten countries in South and Southeast Asia. These data can be used for immediate and long-term analysis and mapping of political violence and protest across developing countries through use of historical data from 1997, as well as informing humanitarian and development work in crisis and conflict-affected contexts through realtime data updates and reports. ACLED data show that political violence rates have remained relatively high and stable in the recent years, despite the waning of civil wars across the developing world. ACLED seeks to support research and work devoted to understanding, predicting and reducing levels of political violence.
