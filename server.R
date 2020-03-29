server = function(input, output, session) {
  
  # Start with Marker Groups Check Box enabled
  shiny::observe({
    shinyjs::enable("marker_groups_check_box")
  })
  
  # Disable Marker Groups Check Box when Markers Check Box is FALSE (enable when TRUE)
  shiny::observe({
    if (input$markers_check_box == FALSE) {
      shinyjs::disable("marker_groups_check_box")
    } else {
      shinyjs::enable("marker_groups_check_box")
    }
  })
  
  # Initialize Reactive Values ----
  reactive_values = reactiveValues(live_api = TRUE,
                                   new_query_count = 0,
                                   previous_query = "",
                                   center_longitude = -121.5,
                                   center_latitude = 38.55, 
                                   zoom = 11)

  # * Save Map Center / Zoom ----
  observeEvent(c(reactive_values$new_query_count,
                 input$map_draw_new_feature,
                 input$marker_picker,
                 input$number_of_observations), { 
    if (!is.null(input$map_zoom)) {
      reactive_values$center_latitude = input$map_center$lat
      reactive_values$center_longitude = input$map_center$lng
      reactive_values$zoom = input$map_zoom
    }
  })
  
  # Dataset ----
  url = reactive({
    input$dataset_picker
  })
  
  data_information = reactive({
    information = get_data_information(url = url())
    
    if (is.null(information)) {
      # Sometimes a HTTP2 errors occurs, if so try again
      information = get_data_information(url = url())
    }
    
    if (is.null(information)) {
      reactive_values$live_api = FALSE
    } else {
      reactive_values$live_api = TRUE
    }
    
    return(information)
    
  })
  
  total_observations = reactive({
    count = get_observation_count(url = url())
    
    if (is.null(count)) {
      # Sometimes a HTTP2 errors occurs, if so try again
      count = get_observation_count(url = url())
    }
    
    if (is.null(count)) {
      reactive_values$live_api = FALSE
    } else {
      reactive_values$live_api = TRUE
    }
    
    return(count)
  })
  
  max_observations = reactive({
    as.integer(min(total_observations(), 10 * data_information()$max_record_count))
  })
  
  # UI Elements ----
  output$number_of_observations_ui = renderUI({
    max_record_count = data_information()$max_record_count
    max_value = max_observations()
   
    tagList(
      shiny::numericInput(inputId = "number_of_observations",
                          label = shiny::h3("Number of Data Points"),
                          value = 100,
                          min = 0,
                          max = max_value),
      shiny::helpText(shiny::HTML(paste0("Maximum ", max_value, ".",
                                         ifelse(max_value > max_record_count, 
                                                paste0("<br/>Note: values over ", max_record_count, " will slow down results."), 
                                                "")
      )))
    )
  })
  
  observeEvent(input$dataset_picker, {
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "filter_picker", 
      choices = sort(data_information()$columns$name),
      selected = NULL)
  })
  
  observeEvent(input$dataset_picker, {
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "marker_picker", 
      choices = sort(data_information()$columns$name),
      selected = NULL)
  })
  
  # * Filters ----
  output$filters = shiny::renderUI({
    filters = input$filter_picker
    number_of_filters = length(filters)
    
    column_information = data_information()$columns
  
    if (number_of_filters > 0 & all(filters %in% column_information$name)) {
      lapply(1:number_of_filters, function(filter_index) {
        create_filter_input(filter_index = filter_index, 
                            filters = filters, 
                            url = url(), 
                            column_information = data_information()$columns)
      })
    } else {
      NULL
    }
  })
  
  # Data ----
  # * Create Query ----
  query_filter = reactive({
    filter_query = "1=1"
   
    filters = input$filter_picker
    number_of_filters = length(filters)
    
    column_information = data_information()$columns
   
    if (!is.null(filters)) {
      if (all(filters %in% column_information$name)) {
        for (filter_index in 1:number_of_filters) {
          variable_name = filters[filter_index]
          variable_type = get_variable_type(variable_name = variable_name,
                                            column_information = column_information)
  
          filter_values = input[[paste0("filter_", filter_index)]]
  
          if (!is.null(filter_values)) {
            if (variable_type %in% range_variable_types) {
              if (variable_type == "date") {
                lower_filter = paste0(" date '", filter_values[1], "' ")
                upper_filter =  paste0(" date '", filter_values[2], "' ")
              } else {
                lower_filter = filter_values[1]
                upper_filter = filter_values[2]
              }
              filter_query = paste0(filter_query, paste0(" AND ", variable_name, " >= ", lower_filter,
                                                         " AND ", variable_name, " <= ", upper_filter))
            } else {
              filter_query = paste0(filter_query, " AND (", variable_name, " = '", paste0(filter_values,
                                                                                          collapse = paste0("' OR ", variable_name, " = '")),
                                                                                          "') ")
            }
          }
        }
      }
    }
    
    return(filter_query)
  })
  
  query_parameters = reactive({
    parameters = list()
    
    if (length(input$map_draw_new_feature) > 0) {
      
      boundaries = as.data.frame(matrix(unlist(input$map_draw_new_feature$geometry$coordinates),
                                        ncol = 2,
                                        byrow = TRUE),
                                 stringsAsFactors = FALSE)
      colnames(boundaries) = c('longitude', 'latitude')
      
      min_longitude = min(boundaries$longitude)
      max_longitude = max(boundaries$longitude)
      min_latitude = min(boundaries$latitude)
      max_latitude = max(boundaries$latitude)

      parameters$geometry = paste0("{'rings':[[
                                              [", min_longitude, ",", min_latitude, "], 
                                              [", min_longitude, ",", max_latitude, "],
                                              [", max_longitude, ",", max_latitude, "],
                                              [", max_longitude, ",", min_latitude, "],
                                              [", min_longitude, ",", min_latitude, "]
                                    ]]}")
      parameters$geometryType = "esriGeometryPolygon"
      parameters$inSR = 4326
      parameters$spatialRel = "esriSpatialRelContains"
    }
    return(parameters)
  })
  
  # Check to see if query has changed, and if so, add 1 to new_query_count reactive value
  observeEvent(query(), {
    if (!is.null(query()) && query() != reactive_values$previous_query) {
      reactive_values$new_query_count = reactive_values$new_query_count + 1
    }
    reactive_values$previous_query = query()
  })
  
  query = reactive({
    paste0(url(), "/where=", query_filter())
  })
  
  # * Query Data ----
  query_data = function(query_limit, offset = 0) {
    data = tryCatch(esri2sf::esri2sf(url = url(), 
                                     where = query_filter(),
                                     additional_parameters = query_parameters(),
                                     limit = query_limit,
                                     offset = offset) %>%
                      as.data.frame(),
                    error = function(err) {
                      NULL
                    })
    return(data)
  }
  
  # Only update data if new query
  filtered_data = eventReactive(c(reactive_values$new_query_count,
                                  input$map_draw_new_feature,
                                  input$number_of_observations), {
    
    req(input$number_of_observations)              
                                    
    rows_to_query = min(input$number_of_observations, max_observations())
    offset = 0
    data = NULL
    max_record_count = data_information()$max_record_count
    rows_returned = max_record_count
    
    # Stop loop if no more rows to query or fewer than max rows returned
    while (rows_to_query > 0 && rows_returned == max_record_count) {   
      query_limit = min(rows_to_query, max_record_count)
      
      new_data = query_data(query_limit = query_limit, 
                            offset = offset)
      
      if (is.null(data)) {
        # Sometimes a HTTP2 errors occurs, if so try again
        new_data = query_data(query_limit = query_limit, 
                              offset = offset)
      }
      
      rows_returned = nrow(new_data)
      
      if (!is.null(new_data) && rows_returned > 0) {
        data = rbind(data, new_data)
      }
      
      offset = offset + query_limit
      rows_to_query = rows_to_query - query_limit
    }
    
    return(unique(data))
  })
  
  # * Map Output ----
  marker_popup = reactive({
    marker_variables = input$marker_picker
    number_marker_variables = length(marker_variables)
    
    column_information = data_information()$columns
    
    if (number_marker_variables > 0 & all(marker_variables %in% column_information$name)) {
      data = filtered_data()
      
      marker_string = ""
      
      for (variable in marker_variables) {
        marker_string = paste0(marker_string, variable, ": ", data[, variable], "<br>")
      }
    } else {
      marker_string = NULL
    }
    
    return(marker_string)
  })
  
  output$map = leaflet::renderLeaflet({
    
    data = filtered_data()

    map = leaflet::leaflet(data = data) %>% 
      leaflet::addTiles() %>%
      leaflet::setView(lat = reactive_values$center_latitude, 
                       lng = reactive_values$center_longitude, 
                       zoom = reactive_values$zoom) %>%
      leaflet.extras::addDrawToolbar(
        targetGroup = 'Selected',
        polylineOptions = FALSE,
        circleMarkerOptions = FALSE,
        markerOptions = FALSE,
        rectangleOptions = leaflet.extras::drawRectangleOptions(shapeOptions = leaflet.extras::drawShapeOptions(fillOpacity = 0,
                                                                                                                color = 'white',
                                                                                                                weight = 3)),
        polygonOptions = FALSE,
        circleOptions = FALSE,
        editOptions = leaflet.extras::editToolbarOptions(edit = FALSE, selectedPathOptions = leaflet.extras::selectedPathOptions()))
    
    if (nrow(data) > 0) {
      data = data %>%
        geom_to_longitude_latitude() %>%
        # Need to filter NAs to avoid javascript error
        filter(!is.na(latitude) & !is.na(longitude))
      
      if (input$markers_check_box) {
        if (input$marker_groups_check_box) {
          map = map %>% 
            leaflet::addMarkers(~data$longitude, 
                                ~data$latitude, 
                                popup = ~marker_popup(),
                                clusterOptions = leaflet::markerClusterOptions())
        } else {
          map = map %>% 
            leaflet::addMarkers(~data$longitude, 
                                ~data$latitude,
                                popup = ~marker_popup())
        }
      }
      
      if (input$heatmap_check_box) {
        map = map %>% 
          leaflet.extras::addHeatmap(~data$longitude, 
                                     ~data$latitude,
                                     radius = 10) 
      }
    }
    
    # ** Add Rectangle ----
    if (length(input$map_draw_new_feature) > 0) {
      boundaries = as.data.frame(matrix(unlist(input$map_draw_new_feature$geometry$coordinates),
                                        ncol = 2, 
                                        byrow = TRUE),
                                 stringsAsFactors = FALSE)
      colnames(boundaries) = c('longitude', 'latitude')
      
      min_longitude = min(boundaries$longitude)
      max_longitude = max(boundaries$longitude)
      min_latitude = min(boundaries$latitude)
      max_latitude = max(boundaries$latitude)
      
      map = map %>%
        leaflet::addRectangles(
          data = data,
          lng1 = min_longitude, lat1 = min_latitude,
          lng2 = max_longitude, lat2 = max_latitude,
          fillColor = "transparent",
          layerId = 'selected_rectangle')
    }
    
    
    return(map)
  })
  
  # * Clear Rectangle ----
  observeEvent(input$clear_rectangle, {
    if (input$clear_rectangle == 'TRUE') {
      # Set inputs (passed as messages) to NULL using the resetInput javascript function
      session$sendCustomMessage(type = "resetInput", message = "map_draw_new_feature")
      session$sendCustomMessage(type = "resetInput", message = "clear_rectangle")
    }
  })
}