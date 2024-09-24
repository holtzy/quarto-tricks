library(shiny)
library(jsonlite)
library(ggplot2)
library(dplyr)

# Define UI for the application
ui <- fluidPage(
  
  # Application title
  titlePanel("Cryptocurrency Price Over the Last Year"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      # Select input for choosing the currency
      selectInput("currency", 
                  "Select a cryptocurrency:", 
                  choices = c("bitcoin", "ethereum", "litecoin"),
                  selected = "bitcoin")
    ),
    
    # Main panel for displaying the plot
    mainPanel(
      plotOutput("pricePlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$pricePlot <- renderPlot({
    
    # Get selected currency
    currency <- input$currency
    
    # Construct the API URL
    end_date <- as.integer(as.POSIXct(Sys.Date()))
    start_date <- as.integer(as.POSIXct(Sys.Date() - 365))
    url <- paste0("https://api.coingecko.com/api/v3/coins/", currency, "/market_chart/range?vs_currency=usd&from=", start_date, "&to=", end_date)
    
    # Fetch the data
    json_data <- readLines(url, warn = FALSE)
    data <- fromJSON(json_data)$prices %>% as.data.frame()
    colnames(data) <- c("timestamp", "value")
    
    # Format the date (date is provided in milliseconds, hence the division by 1000)
    data$timestamp <- as.POSIXct(data$timestamp / 1000, origin = "1970-01-01", tz = "UTC")
    
    # Plot the data
    ggplot(data, aes(x = timestamp, y = value)) +
      geom_line() +
      labs(title = paste0("Price of ", currency, " Over the Last Year"), 
           x = "Date", y = "Price (USD)")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
