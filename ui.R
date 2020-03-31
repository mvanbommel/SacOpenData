# Header ----
header = shinydashboard::dashboardHeader(
  title = "Sacramento Open Data",
  
  tags$li(class = "dropdown",
          tags$li(class = "dropdown navbar-button", 
                  id = "github_button",
                  shiny::actionButton(inputId = "github_button",
                                      label = "",
                                      icon = icon("github", "fa-3x"),
                                      onclick ="window.open('https://github.com/mvanbommel/SacOpenData', '_blank')"))
          
  )
)

# Sidebar ----
sidebar = shinydashboard::dashboardSidebar(
  width = '325',
  
  shinyWidgets::pickerInput(
    inputId = "dataset_picker", 
    label = shiny::h3("Select Dataset"), 
    choices = dataset_picker_vector
  ),
  
  shiny::uiOutput(outputId = "number_of_observations_ui"),
  
  shinyWidgets::pickerInput(
    inputId = "filter_picker", 
    label =shiny::h3("Add Filter"), 
    choices = "Waiting for Data to Load",
    options = list(`none-selected-text` = "Select Filter to Add",
                   `selected-text-format` = "count > 1",
                   `actions-box` = TRUE,
                   `live-search` = TRUE), 
    multiple = TRUE
  ),
  
  shiny::uiOutput(outputId = "filters"),
  
  shinyWidgets::pickerInput(
    inputId = "marker_picker", 
    label = shiny::h3("Markers"), 
    choices = "Waiting for Data to Load",
    options = list(`none-selected-text` = "Select Marker Values to Display",
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

# Body ----
body = shinydashboard::dashboardBody(
  shinyjs::useShinyjs(),
  tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  tags$script(src = "scripts.js"),
  shiny::tabsetPanel(type = "tabs",
    shiny::tabPanel(title = "Map", leaflet::leafletOutput("map")),
    shiny::tabPanel(title = "Data", 
                    shiny::downloadButton(outputId = "download_data",
                                          label = "Download"),
                    reactable::reactableOutput("data"))
  )
)

# Page ----
shinydashboard::dashboardPage(
  header,
  sidebar,
  body
)