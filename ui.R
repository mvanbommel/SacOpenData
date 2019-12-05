sidebar = shinydashboard::dashboardSidebar(
  width = '325',
  
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
  shinydashboard::dashboardHeader(title = data_information$name),
  sidebar,
  body
)