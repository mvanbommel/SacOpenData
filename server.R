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
  
  url = reactive({
    input$dataset_picker
  })
  
  data_information = reactive({
    get_data_information(url = url())
  })
  
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
    
    if (number_of_filters > 0) {
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
  
  # * Map Output ----
  output$map = leaflet::renderLeaflet({
 
    data = esri2sf::esri2sf(url = url(), 
                            where = "1=1",
                            limit = data_information()$max_record_count) %>%
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