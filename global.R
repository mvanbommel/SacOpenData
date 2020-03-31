`%>%` = dplyr::`%>%`

# TO DO ----
# * fix HTTP error on load (still an issue?)
# * loading animation
# * test datasets
# * make table look better
# * notificaiton during query?
# * add links to City of Sac page
# * CSS tooltips for buttons?
# * alphabetize datasets

# Next Step:


# Generalizing to Other data providers
# * changing dataset_name, and datasets
# * editing geom_to_longitude_latitude()

# DATA ----
# * Data Sources ----
dataset_list = list(
  list(name = "City Maintained Trees",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/City_Maintained_Trees/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/b9b716e09b5048179ab648bb4518452b_0"),
  list(name = "Crime Data From Current Year",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/general_offenses_year3/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/64279ca193a54189aa9214a29d32520c_0"),
  list(name = "Crime Data From One Year Ago",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/general_offenses_year2/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/0026878c24454e16b169b3fb26130751_0"),
  list(name = "Crime Data From Two Years Ago",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/general_offenses_year1/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/84e4483fc0624d678d7608a4fa12aae1_0"),
  list(name = "Crime Data 2017",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Sacramento_Crime_Data_2017/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/6023972e7b994c58bf87c4424b60539b_0"),
  list(name = "Crime Data 2016",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Sacramento_Crime_Data_2016/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/64ab02f77ad94bfb807e501c57f720e8_0"),
  list(name = "Crime Data 2015",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Sacramento_Crime_Data_2015/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/bdf818394cc1460da18c2265b8234892_0"),
  list(name = "Crime Data 2014",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Sacramento_Crime_Data_2014/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/3bea9eb86f894c88930cecc583ed5a71_0"),
  list(name = "Dispatch Data From Current Year",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/cad_calls_year3/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/9efe7653009b448f8d177c1da0cc068f_0"),
  list(name = "Dispatch Data From One Year Ago",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/cad_calls_year2/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/396e0bc72dcd4b038206f4a7239792bb_0"),
  list(name = "Dispatch Data From Two Years Ago",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/cad_calls_year1/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/1692315bba964832b235a76755928c06_0"),
  list(name = "Dispatch Data 2017",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/CAD_2017/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/d6c26871b5ca46dca132c7707d9e80e8_0"),
  list(name = "Dispatch Data 2016",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Sacramento_Dispatch_Data_2016/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/4bdb47c80f844d779795f62b35b83984_0"),
  list(name = "Dispatch Data 2015",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Sacramento_Dispatch_Data_2015/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/44ed3f7800c7479a910332b4b7795290_0"),
  list(name = "Dispatch Data 2014",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/CAD_2014/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/e5f7cee6406941ed97e8a3109a301431_0"),
  list(name = "EV Chargers",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/EV_Chargers/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/93efdbcdbc744210848dd7f601e622e3_0"),
  list(name = "Fire Department 911 Call Response",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/GetNFIRSRespondReport/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/0b32edde7b14480e82d0d746108431db_0"),
  list(name = "Fire Stations",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Fire_Stations/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/614bdde2a4714b2098d4c2532fd2c6e7_0"),
  list(name = "GPS Static Survey",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/GPS_StaticSurvey/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/5a5fb0a127ff44ad98f8a48640e9529c_0"),
  list(name = "Hospitals",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Hospitals/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/0363364d7ddb4ff4aadd7057187a7a05_0"),
  list(name  = "Off Street Parking",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/PublicAccessParkingMapService/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/1a75cd6cbadc4059990cd40620d81c56_0"),
  list(name = "On Street Parking",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/ONSTREETPARKING/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/0060469c57864becb76a036d23236143_0"),
  list(name = "Parks Public Restrooms",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Parks_Public_Restrooms/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/b9e7fa6d1d104833b3f04268d7f682dc_0"),
  list(name = "Schools",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Schools/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/fd3677bd8ff44a2cbe6b8cc67a3d2c1c_0"),
  list(name = "Signs",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Signs/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/669f377150b74ae4863b5eefbdde39b7_0"),
  list(name = "Street Lights",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Street_Lights/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/3dca1faa7e0a40f79f31f95c0b2ebd17_0"),
  list(name = "Streetcar Stops (Proposed)",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Streetcar_Stops/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/5922bb984d8748d1a457164d4416dced_0"),
  list(name = "Survey Benchmarks",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/SurveyBenchmarks/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/53244a1d3ca447d8a890ad6bbc43621b_0"),
  list(name = "311 Calls",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/311Calls_OSC_View/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/08794a6695b3483f889e9bef122517e9_0")
)

dataset_df = dplyr::bind_rows(lapply(dataset_list, data.frame, stringsAsFactors = FALSE))

dataset_picker_vector = dataset_df$api
names(dataset_picker_vector) = dataset_df$name


# Initialize data_information for load (will update with observeEvent)
data_information = NULL

range_variable_types = c("smallinteger", "integer", "single", "double", "oid", "date")

# FUNCTIONS ----
# * Utility ----
epoch_to_calendar_date = function(epoch) {
  as.Date(as.POSIXct(epoch / 1000, 
                     origin = '1970-01-01',
                     tz = 'America/Los_Angeles'),
          format = '%y-%m-%d')
}

geom_to_longitude_latitude = function(data) {
  
  if (!is.null(data)) {
    if ("geoms" %in% colnames(data)) {
      coordinates = do.call(rbind, sf::st_geometry(data$geoms)) %>% 
        as.data.frame(row.names = as.character(1:nrow(data))) %>% 
        setNames(c("longitude", "latitude"))
      
      # Missing Latitude and Longitude to NA
      coordinates$longitude[coordinates$longitude < -142] = NA
      coordinates$latitude[coordinates$latitude < 32] = NA
      
      data = cbind(data, coordinates) %>%
        dplyr::select(-geoms)
    }
  }
  
  data
  
}

# * Data ----
get_data_information = function(url) {
  json = tryCatch(jsonlite::fromJSON(txt = paste0(url, "/?f=pjson")),
                  error = function(err) {
                    NULL
                  })
  
  if (!is.null(json)) {
    information = list(name = json$name, 
                       max_record_count = json$maxRecordCount,
                       columns = json$fields)
  } else {
    information = NULL
  }
  
  return(information)
}

get_observation_count = function(url, where = "1=1") {
  count = tryCatch(R.utils::withTimeout(jsonlite::fromJSON(txt = paste0(url, "/query?where=", where, "&outFields=*&returnDistinctValues=true&returnCountOnly=true&outSR=4326&f=json"))$count,
                                        timeout = 5,
                                        onTimeout = 'error'),
                   error = function(err) {
                     NULL
                   })
  
  return(count)
}

# * Filter ----
get_variable_type = function(variable_name, column_information) {
  variable_type = column_information %>%
    dplyr::filter(variable_name == name) %>%
    dplyr::mutate(type = tolower(stringr::str_replace(string = type, pattern = "esriFieldType", replacement = ""))) %>%
    dplyr::pull(type)
  
  return(variable_type)
}

get_filter_values = function(url, variable, variable_type) {
  if (variable_type %in% range_variable_types) {
    min_value = jsonlite::fromJSON(paste0(url, "/query?where=", variable, "%20IS%20NOT%20NULL&outFields=", variable, "&orderByFields=", variable, "&returnGeometry=false&resultRecordCount=1&outSR=4326&f=json"))$features$attributes[, 1]
    max_value = jsonlite::fromJSON(paste0(url, "/query?where=", variable, "%20IS%20NOT%20NULL&outFields=", variable, "&orderByFields=", variable, "%20DESC&returnGeometry=false&resultRecordCount=1&outSR=4326&f=json"))$features$attributes[, 1]
    
    if (variable_type == "date") {
      min_value = epoch_to_calendar_date(epoch = min_value)
      max_value = epoch_to_calendar_date(epoch = max_value)
    }
    
    values = c(min_value, max_value)
  } else {
    values = jsonlite::fromJSON(paste0(url, "/query?where=1=1&outFields=", variable, "&returnGeometry=false&returnDistinctValues=true&outSR=4326&f=json"))$features$attributes[, 1]
  }
  
  return(values)
}

create_filter_input = function(filter_index, filters, url, column_information) {
  
  variable_type = get_variable_type(variable_name = filters[filter_index],
                                    column_information = column_information)
  
  filter_input_id = paste0("filter_", filter_index)
  filter_label = shiny::h4(filters[filter_index])
  filter_values = get_filter_values(url = url, variable = filters[filter_index], variable_type = variable_type)
  
  if (variable_type == "integer") {
    input = shinyWidgets::numericRangeInput(inputId = filter_input_id,
                                            label = filter_label,
                                            value = c(filter_values[1], filter_values[2]))
  } else if (variable_type == "date") { 
    input = shiny::dateRangeInput(inputId = filter_input_id, 
                                  label = filter_label,
                                  start = filter_values[1],
                                  end = filter_values[2],
                                  min = filter_values[1],
                                  max = filter_values[2])
  } else {
    input = shinyWidgets::pickerInput(inputId = filter_input_id,
                                      label = filter_label, 
                                      choices = filter_values,
                                      options = list(`none-selected-text` = "Select Filtering Values",
                                                     `selected-text-format` = "count > 1",
                                                     `actions-box` = TRUE,
                                                     `live-search` = TRUE), 
                                      multiple = TRUE)
  }
  
  return(input)
}