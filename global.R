`%>%` = dplyr::`%>%`

# TO DO ----
# * allow user to add inputs (use info in data_information$columns to determine input type)
# * marker information - let user select columns to display?
# * search by drawing box on map
#

# Next Step:
# Replace "Waiting for Data to Load", in output$filters

# DATA ----
# Initialize data_information for load (will update with observeEvent)
data_information = NULL

# FUNCTIONS ----
get_data_information = function(url) {
  json = jsonlite::fromJSON(txt = paste0(url, "/?f=pjson"))
  
  information = list(name = json$name, 
                     max_record_count = json$maxRecordCount,
                     columns = json$fields)
}

geom_to_longitude_latitude = function(data) {
  
  if ("geoms" %in% colnames(data)) {
    coordinates = do.call(rbind, sf::st_geometry(data$geoms)) %>% 
      as.data.frame() %>% 
      setNames(c("longitude", "latitude"))
    
    # Missing Latitude and Longitude to NA
    coordinates$longitude[coordinates$longitude < -142] = NA
    coordinates$latitude[coordinates$latitude < 32] = NA
      
    data = cbind(data, coordinates) %>%
      dplyr::select(-geoms)
  }
  
  data

}


# URL ----
dataset_names = c("City Maintained Trees",
                  "Dispatch Data")

datasets = c("https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/City_Maintained_Trees/FeatureServer/0",
             "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/cad_calls_year3/FeatureServer/0")

names(datasets) = dataset_names
         