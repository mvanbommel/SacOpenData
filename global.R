`%>%` = dplyr::`%>%`

# FUNCTIONS ----
get_data_information = function(url) {
  json = jsonlite::fromJSON(txt = paste0(url, "/?f=pjson"))
  
  information = list(name = json$name, 
                     max_record_count = json$maxRecordCount)
}

geom_to_longitude_latitude = function(data) {
  
  if ("geoms" %in% colnames(data)) {
    coordinates = do.call(rbind, sf::st_geometry(data$geoms)) %>% 
      as.data.frame() %>% 
      setNames(c("longitude", "latitude"))
    
    data = cbind(data, coordinates) %>%
      dplyr::select(-geoms)
  }
  
  data

}


# URL ----
url = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/City_Maintained_Trees/FeatureServer/0"

data_information = get_data_information(url = url)