library(shiny)
library(jsonlite)
library(ggplot2)
library(dplyr)
library(shinylive)

ui <- fluidPage(
  fluidRow(
    column(
      2,
      selectInput("currency",
        "Select a cryptocurrency:",
        choices = c(
          "bitcoin", "ethereum", "tether", "binancecoin", "ripple",
          "solana", "cardano", "dogecoin", "polygon", "polkadot",
          "litecoin", "bitcoin-cash", "chainlink", "stellar", "uniswap",
          "monero", "ethereum-classic", "cosmos", "tron", "vechain",
          "theta", "filecoin", "aave", "shiba-inu", "algorand",
          "hedera", "elrond", "fantom", "near-protocol", "quant",
          "dash", "zilliqa", "sushi", "eos", "bitcoin-gold",
          "kava", "celo", "okb", "harmony", "chiliz",
          "render-token", "decentraland", "the-sandbox", "curve-dao-token", "yearn-finance",
          "iota", "sandbox", "pancakeswap-token", "nexo", "waves"
        ), selected = "bitcoin"
      )
    ),
    column(
      2,
      sliderInput("lineWidth",
        "Select line width:",
        min = 0.5, max = 5, value = 1, step = 0.5
      )
    ),
    column(
      2,
      selectInput("lineColor",
        "Select line color:",
        choices = c("blue", "red", "green", "purple", "black"),
        selected = "blue"
      )
    )
  ),

  # Main panel for displaying the plot
  mainPanel(
    plotOutput("pricePlot")
  )
)

# Define server logic
server <- function(input, output) {
  output$pricePlot <- renderPlot({
    # Get selected currency, line width, and line color
    currency <- input$currency
    lineWidth <- input$lineWidth
    lineColor <- input$lineColor

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

    # Plot the data with dynamic line width and color
    ggplot(data, aes(x = timestamp, y = value)) +
      geom_line(size = lineWidth, color = lineColor) +
      labs(
        title = paste0("Price of ", currency, " Over the Last Year"),
        x = "Date", y = "Price (USD)"
      )
  })
}

# Run the application
shinyApp(ui = ui, server = server)

