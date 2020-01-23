sidebar = shinydashboard::dashboardSidebar(
  width = '325',
  
  shinyWidgets::pickerInput(
    inputId = "dataset_picker", 
    label = h3("Select Dataset"), 
    choices = datasets
  ),
  
  shinyWidgets::pickerInput(
    inputId = "filter_picker", 
    label = h3("Add Filter"), 
    choices = "Waiting for Data to Load",
    options = list(`none-selected-text` = "Select Filter to Add",
                   `selected-text-format` = "count > 1",
                   `actions-box` = TRUE,
                   `live-search` = TRUE), 
    multiple = TRUE
  ),
  
  shinyWidgets::prettyCheckbox(
    inputId = "markers_check_box",
    label = "Markers",
    value = TRUE,
    icon = icon("check-square-o"), 
    status = "primary",
    outline = TRUE
  ),
  
  shinyWidgets::prettyCheckbox(
    inputId = "marker_groups_check_box",
    label = "Marker Groups",
    value = TRUE,
    icon = icon("check-square-o"), 
    status = "primary",
    outline = TRUE
  ),
  
  shinyWidgets::prettyCheckbox(
    inputId = "heatmap_check_box",
    label = "Heatmap",
    value = TRUE,
    icon = icon("check-square-o"), 
    status = "primary",
    outline = TRUE
  )
)

body = shinydashboard::dashboardBody(
  shinyjs::useShinyjs(),
  leaflet::leafletOutput("map")
)

shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title = "Sacramento Open Data"),
  sidebar,
  body
)