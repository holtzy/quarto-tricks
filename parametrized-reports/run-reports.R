# Load required library
library(quarto)

# List of cryptocurrencies
cryptos <- c("bitcoin", "ethereum", "ripple", "litecoin", "cardano")

# Path to the Quarto report
report_path <- "/Users/yanholtz/Desktop/quarto-tricks/parametrized-reports/index.qmd"  

# Directory to save the rendered reports
output_dir <- "/Users/yanholtz/Desktop/quarto-tricks/parametrized-reports/reports"


# Loop through each cryptocurrency and render the report
for (crypto in cryptos) {
  
  quarto_render(
    input = report_path, 
    output_file = paste0("report_" , crypto , ".html")
    params = list(crypto = crypto),
    
  )
    
    
}
