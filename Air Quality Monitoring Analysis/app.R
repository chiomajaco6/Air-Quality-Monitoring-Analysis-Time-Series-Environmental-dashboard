library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(forecast)
library(DT)

# ---- DATA PREP ----
airdata <- read.csv("dataset.csv", sep = ",", header = FALSE)
colnames(airdata) <- c("CO", "NO2", "NOx", "O3", "PM2.5", "Temperature", "Category")
airdata$Time <- 1:nrow(airdata)
airdata[airdata == -200] <- NA
airdata <- airdata %>%
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), mean(., na.rm = TRUE), .)))

# ---- UI ----
ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Air Quality Monitor"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview",    tabName = "overview",   icon = icon("chart-line")),
      menuItem("Time Series", tabName = "timeseries", icon = icon("clock")),
      menuItem("Correlation", tabName = "corr",       icon = icon("th")),
      menuItem("Forecast",    tabName = "forecast",   icon = icon("eye")),
      menuItem("Data Table",  tabName = "table",      icon = icon("table"))
    ),
    selectInput("pollutant", "Select Pollutant:",
                choices = c("CO", "NO2", "NOx", "O3", "PM2.5", "Temperature"),
                selected = "CO"),
    sliderInput("obs", "Number of Observations:",
                min = 100, max = 1845, value = 500, step = 100)
  ),
  dashboardBody(
    tabItems(
      
      # OVERVIEW
      tabItem(tabName = "overview",
              fluidRow(
                valueBoxOutput("avg_box"),
                valueBoxOutput("max_box"),
                valueBoxOutput("min_box")
              ),
              fluidRow(
                box(title = "Pollutant Trend",  width = 8, plotlyOutput("trend_plot")),
                box(title = "Distribution",     width = 4, plotlyOutput("dist_plot"))
              )
      ),
      
      # TIME SERIES
      tabItem(tabName = "timeseries",
              fluidRow(
                box(title = "Full Time Series",       width = 12, plotlyOutput("full_ts"))
              ),
              fluidRow(
                box(title = "CO vs NO2 Comparison",   width = 12, plotlyOutput("compare_plot"))
              )
      ),
      
      # CORRELATION
      tabItem(tabName = "corr",
              fluidRow(
                box(title = "Correlation Heatmap",                        width = 12, plotlyOutput("corr_plot"))
              ),
              fluidRow(
                box(title = "Scatter: Selected Pollutant vs Temperature", width = 12, plotlyOutput("scatter_plot"))
              )
      ),
      
      # FORECAST
      tabItem(tabName = "forecast",
              fluidRow(
                box(title = "30-Step Forecast", width = 12, plotlyOutput("forecast_plot"))
              )
      ),
      
      # DATA TABLE
      tabItem(tabName = "table",
              fluidRow(
                box(title = "Raw Data", width = 12, DT::DTOutput("data_table"))
              )
      )
    )
  )
)

# ---- SERVER ----
server <- function(input, output, session) {
  
  filtered <- reactive({
    airdata[1:input$obs, ]
  })
  
  output$avg_box <- renderValueBox({
    val <- round(mean(filtered()[[input$pollutant]], na.rm = TRUE), 2)
    valueBox(val, paste("Avg", input$pollutant), icon = icon("tachometer-alt"), color = "blue")
  })
  
  output$max_box <- renderValueBox({
    val <- round(max(filtered()[[input$pollutant]], na.rm = TRUE), 2)
    valueBox(val, paste("Max", input$pollutant), icon = icon("arrow-up"), color = "red")
  })
  
  output$min_box <- renderValueBox({
    val <- round(min(filtered()[[input$pollutant]], na.rm = TRUE), 2)
    valueBox(val, paste("Min", input$pollutant), icon = icon("arrow-down"), color = "green")
  })
  
  output$trend_plot <- renderPlotly({
    plot_ly(filtered(), x = ~Time, y = ~get(input$pollutant),
            type = "scatter", mode = "lines",
            line = list(color = "#2ecc71")) %>%
      layout(xaxis = list(title = "Observation"),
             yaxis = list(title = input$pollutant))
  })
  
  output$dist_plot <- renderPlotly({
    plot_ly(filtered(), x = ~get(input$pollutant),
            type = "histogram",
            marker = list(color = "#3498db")) %>%
      layout(xaxis = list(title = input$pollutant),
             yaxis = list(title = "Count"))
  })
  
  output$full_ts <- renderPlotly({
    plot_ly(filtered(), x = ~Time, y = ~get(input$pollutant),
            type = "scatter", mode = "lines",
            fill = "tozeroy",
            line = list(color = "#e74c3c")) %>%
      layout(xaxis = list(title = "Observation"),
             yaxis = list(title = input$pollutant))
  })
  
  output$compare_plot <- renderPlotly({
    plot_ly(filtered(), x = ~Time) %>%
      add_lines(y = ~CO,  name = "CO",  line = list(color = "#e74c3c")) %>%
      add_lines(y = ~NO2, name = "NO2", line = list(color = "#3498db")) %>%
      layout(xaxis = list(title = "Observation"),
             yaxis = list(title = "Value"))
  })
  
  output$corr_plot <- renderPlotly({
    num_data <- filtered() %>%
      select(CO, NO2, NOx, O3, PM2.5, Temperature) %>%
      na.omit()
    corr_mat <- round(cor(num_data), 2)
    plot_ly(x = colnames(corr_mat),
            y = rownames(corr_mat),
            z = corr_mat,
            type = "heatmap",
            colorscale = "RdBu",
            zmin = -1, zmax = 1)
  })
  
  output$scatter_plot <- renderPlotly({
    plot_ly(filtered(),
            x = ~Temperature,
            y = ~get(input$pollutant),
            type = "scatter", mode = "markers",
            marker = list(color = "#9b59b6", opacity = 0.5)) %>%
      layout(xaxis = list(title = "Temperature"),
             yaxis = list(title = input$pollutant))
  })
  
  output$forecast_plot <- renderPlotly({
    ts_data  <- ts(filtered()[[input$pollutant]], frequency = 7)
    fit      <- ets(ts_data)
    fcast    <- forecast(fit, h = 30)
    actual   <- as.numeric(ts_data)
    predicted <- as.numeric(fcast$mean)
    lo95     <- as.numeric(fcast$lower[, 2])
    hi95     <- as.numeric(fcast$upper[, 2])
    n        <- length(actual)
    x_fore   <- (n + 1):(n + 30)
    
    plot_ly() %>%
      add_lines(x = 1:n, y = actual,
                name = "Actual", line = list(color = "#2ecc71")) %>%
      add_lines(x = x_fore, y = predicted,
                name = "Forecast", line = list(color = "#e74c3c", dash = "dash")) %>%
      add_ribbons(x = x_fore, ymin = lo95, ymax = hi95,
                  name = "95% CI",
                  fillcolor = "rgba(231,76,60,0.2)",
                  line = list(color = "transparent")) %>%
      layout(xaxis = list(title = "Observation"),
             yaxis = list(title = input$pollutant))
  })
  
  output$data_table <- DT::renderDT({
    DT::datatable(filtered(),
                  options = list(pageLength = 15, scrollX = TRUE),
                  rownames = FALSE)
  })
}

# ---- RUN ----
shinyApp(ui, server)