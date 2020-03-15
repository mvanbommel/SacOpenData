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
  reactive_values = shiny::reactiveValues()
  reactive_values$new_query_count = 0
  reactive_values$previous_query = ""

  
  # Dataset ----
  url = reactive({
    input$dataset_picker
  })
  
  data_information = reactive({
    get_data_information(url = url())
  })
  
  # Filters ----
  observeEvent(input$dataset_picker, {
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "filter_picker", 
      choices = data_information()$columns$name,
      selected = NULL)
  })
  
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
      
      # if (length(input$dispatch_map_draw_new_feature) > 0) {
      #   
      #   boundaries = as.data.frame(matrix(unlist(input$dispatch_map_draw_new_feature$geometry$coordinates),
      #                                     ncol = 2, 
      #                                     byrow = TRUE),
      #                              stringsAsFactors = FALSE)
      #   colnames(boundaries) = c('longitude', 'latitude')
      #   
      #   min_longitude = min(boundaries$longitude)
      #   max_longitude = max(boundaries$longitude)
      #   min_latitude = min(boundaries$latitude)
      #   max_latitude = max(boundaries$latitude)
      #   
      #   # Convert longitude and latitude to X and Y for query
      #   min_X_Coordinate = predict(longitude_model, newdata = data.frame(longitude = min_longitude))
      #   max_X_Coordinate = predict(longitude_model, newdata = data.frame(longitude = max_longitude))
      #   min_Y_Coordinate = predict(latitude_model, newdata = data.frame(latitude = min_latitude))
      #   max_Y_Coordinate = predict(latitude_model, newdata = data.frame(latitude = max_latitude))
      #   
      #   shape_filter = paste0(" AND X_Coordinate >= ", min_X_Coordinate,
      #                         " AND X_Coordinate <= ", max_X_Coordinate,
      #                         " AND Y_Coordinate >= ", min_Y_Coordinate,
      #                         " AND Y_Coordinate <= ", max_Y_Coordinate,
      #                         " ")
      #   
      #   query = paste0(query, shape_filter)
      #   
      # }
    }
    
    return(filter_query)
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
  
  # Only update data if new query
  filtered_data = eventReactive(reactive_values$new_query_count, {
    data = esri2sf::esri2sf(url = url(), 
                            where = query_filter(),
                            #limit = data_information()$max_record_count) %>%
                            limit = 10) %>%
      as.data.frame() %>%
      geom_to_longitude_latitude()
  })
  
  # * Map Output ----
  output$map = leaflet::renderLeaflet({
 
    data = filtered_data() %>%
      # Need to filter NAs to avoid javascript error
      filter(!is.na(latitude) & !is.na(longitude))
    
    map = leaflet::leaflet(data = data) %>% 
      leaflet::addTiles() 
    
    if (input$markers_check_box) {
      if (input$marker_groups_check_box) {
        map = map %>% 
          leaflet::addMarkers(~data$longitude, 
                              ~data$latitude, 
                              clusterOptions = leaflet::markerClusterOptions())
      } else {
        map = map %>% 
          leaflet::addMarkers(~data$longitude, 
                              ~data$latitude)
      }
    }
    
    if (input$heatmap_check_box) {
      map = map %>% 
        leaflet.extras::addHeatmap(~data$longitude, 
                                   ~data$latitude,
                                   radius = 10) 
    }
    
    return(map)
  })
}