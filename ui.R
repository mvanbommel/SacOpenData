# Header ----
header = shinydashboard::dashboardHeader(
  title = title,
  tags$li(class = "dropdown",
    tags$li(class = "navbar-button", 
            shiny::actionButton(inputId = "github_button",
                                label = "",
                                icon = shiny::icon("github", "fa-3x"),
                                onclick = "window.open('https://github.com/mvanbommel/SacOpenData', '_blank')")),
    tags$li(class = "navbar-button", 
            shiny::actionButton(inputId = "data_source_button",
                                label = "",
                                icon = shiny::icon("info-circle", "fa-3x"))),
    tags$li(class = "navbar-button",
            shiny::actionButton(inputId = "help_button",
                                label = "",
                                icon = shiny::icon("question-circle", "fa-3x")))
  )
)

# Sidebar ----
sidebar = shinydashboard::dashboardSidebar(
  width = '325',
  
  rintrojs::introBox(
    shinyWidgets::pickerInput(
      inputId = "dataset_picker", 
      label = shiny::h3("Select Dataset"), 
      choices = dataset_picker_vector
    ),
    data.step = 1,
    data.intro = "Select a dataset from the drop down list."
  ),
  
  rintrojs::introBox(
    shiny::uiOutput(outputId = "number_of_observations_ui"),
    data.step = 2,
    data.intro = "Select the number of points to display. Note that large values will slow loading times."
  ),
  
  rintrojs::introBox(
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
    data.step = 3,
    data.intro = "Select variables on which to filter the dataset, and filters will automatically appear below."
  ),
  
  shiny::uiOutput(outputId = "filters"),
  
  rintrojs::introBox(
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
    data.step = 4,
    data.intro = "Markers are the points that appear on the map. Use this drop down to select what information is displayed when a marker is clicked."
  ),
    
  rintrojs::introBox(
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
    ),
    data.step = 5,
    data.intro = "Use these checkboxes to alter how the markers are displayed."
  )
)

# Body ----
body = shinydashboard::dashboardBody(
  shinyjs::useShinyjs(),
  rintrojs::introjsUI(),
  
  # Tooltoips
  tippy::tippy_this(elementId = "github_button", 
                    tooltip = "View Code on GitHub", 
                    placement = "bottom",
                    size = "large"),
  tippy::tippy_this(elementId = "data_source_button", 
                    tooltip = "View Dataset Source", 
                    placement = "bottom",
                    size = "large"),
  tippy::tippy_this(elementId = "help_button", 
                    tooltip = "Launch Interactive Help", 
                    placement = "bottom",
                    size = "large"),
  
  tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  tags$script(src = "scripts.js"),
  
  rintrojs::introBox(
    shiny::tabsetPanel(type = "tabs",
      shiny::tabPanel(title = "Map", leaflet::leafletOutput("map")),
      shiny::tabPanel(title = "Data", 
                      shiny::div(class = "center",
                        shiny::downloadButton(outputId = "download_data",
                                              label = "Download"),
                        shiny::br(),
                        reactable::reactableOutput("data"))
      )
    ),
    data.step = 6,
    data.intro = "In the Map tab:<br>
                  - the +/- buttons can be used to zoom in and out<br>
                  - the square button allows you to draw a shape on the map that will filter results to be within that region<br>
                  - the trash button allows you to delete your drawn shape<br>
                  <br>
                  In the Data tab:<br>
                  - the data is presented in table form with all columns<br>
                  - there is a button to download the data<br>
                  <br>
                  Happy exploring!"
  )
)

# Page ----
shinydashboard::dashboardPage(
  header,
  sidebar,
  body
)