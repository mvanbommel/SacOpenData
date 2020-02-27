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
  
  observeEvent(input$dataset_picker, {
    data_information = get_data_information(url = input$dataset_picker)

    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "filter_picker", 
      choices = data_information$columns$name,
      selected = NULL)
  })
  
  output$filters = shiny::renderUI({
    number_of_filters = length(input$filter_picker)
    if (number_of_filters > 0) {
      lapply(1:number_of_filters, function(filter_index) {
        shinyWidgets::pickerInput(inputId = paste0("filter_", filter_index),
                                  label = h3(input$filter_picker[filter_index]), 
                                  choices = "Waiting for Data to Load",
                                  options = list(`none-selected-text` = "Select Filtering Values",
                                                 `selected-text-format` = "count > 1",
                                                 `actions-box` = TRUE,
                                                 `live-search` = TRUE), 
                                  multiple = TRUE)
      })
    } else {
      NULL
    }
  })
  
  # * Map Output ----
  output$map = leaflet::renderLeaflet({

    url = input$dataset_picker
   
    data_information = get_data_information(url = url)
 
    data = esri2sf::esri2sf(url = url, 
                            where = "1=1",
                            limit = data_information$max_record_count) %>%
      as.data.frame() %>%
      geom_to_longitude_latitude() %>%
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