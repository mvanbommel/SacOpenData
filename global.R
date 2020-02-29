`%>%` = dplyr::`%>%`

# TO DO ----
# * allow user to add inputs (use info in data_information$columns to determine input type)
# * marker information - let user select columns to display?
# * search by drawing box on map
#

# Next Step:
# Add other variable types to create_filter_input() below

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

get_filter_values = function(url, variable, variable_type) {
  if (variable_type == "integer") {
    #
    # Finish here
    #
  } else {
    values = jsonlite::fromJSON(paste0(url, "/query?where=1=1&outFields=", variable, "&returnGeometry=false&returnDistinctValues=true&outSR=4326&f=json"))$features$attributes
    return(values[, 1])
  }
}

create_filter_input = function(filter_index, filters, url, column_information) {
  variable_type = column_information %>%
    dplyr::filter(name == filters[filter_index]) %>%
    dplyr::mutate(type = tolower(stringr::str_replace(string = type, pattern = "esriFieldType", replacement = ""))) %>%
    dplyr::pull(type)
  
  filter_input_id = paste0("filter_", filter_index)
  filter_label = h3(filters[filter_index])
  
  if (variable_type == "integer") {
    shiny::sliderInput(inputId = filter_input_id,
                       label = filter_label,
                       #
                       # Finish here
                       #
                       )
  } else {
    shinyWidgets::pickerInput(inputId = filter_input_id,
                              label = filter_label, 
                              choices = get_filter_values(url = url, variable = filters[filter_index], variable_type = variable_type),
                              options = list(`none-selected-text` = "Select Filtering Values",
                                             `selected-text-format` = "count > 1",
                                             `actions-box` = TRUE,
                                             `live-search` = TRUE), 
                              multiple = TRUE)
  }
}



# URL ----
dataset_names = c("City Maintained Trees",
                  "Dispatch Data")

datasets = c("https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/City_Maintained_Trees/FeatureServer/0",
             "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/cad_calls_year3/FeatureServer/0")

names(datasets) = dataset_names
         

