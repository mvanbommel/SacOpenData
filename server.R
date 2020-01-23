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
  
  observeEvent(input$dataset_picker, {
    data_information = get_data_information(url = input$dataset_picker)
    
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "filter_picker", 
      choices = data_information$columns$name,
      selected = NULL)
  })
  
  # * Map Output ----
  output$map = leaflet::renderLeaflet({
    
    data = esri2sf::esri2sf(url = input$dataset_picker, 
                            where = "1=1",
                            limit = data_information$max_record_count) %>%
      as.data.frame() %>%
      geom_to_longitude_latitude()
    
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