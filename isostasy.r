#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Isostasy Simulator"),

    # Sidebar with slides for data input
    sidebarLayout(
        sidebarPanel(
          
          h4("Use the sliders below to input density and size parameters."),
          
          p("Starting parameters:"),
          
          p("Fluid density = 5"),
          
          p("Block Density = 2"),
          
          p("Block height = 50"),
          
          sliderInput("fluid.density",
                        "Fluid Density (g/cm3)",
                        min = 0,
                        max = 10.0,
                        value = 5, step = 0.1),
            
            sliderInput("block.density",
                        "Block Density (g/cm3)",
                        min = 0,
                        max = 10.0,
                        value = 2, step = 0.1),
            
            sliderInput("block.height",
                        "Block Height (cm)",
                        min = 0,
                        max = 100,
                        value = 50)
        ),

        # Main panel for block analysis
        mainPanel(
           
          # Output: Formatted text
          h3("Results"),
          
          tableOutput("values"),
          
          plotOutput("blockPlot")
        )
    )
)

# Define server logic
server <- function(input, output) {
   
  sliderValues <- reactive({
    
    data.frame(
      Name = c("Fluid Density",
               "Block Density",
               "Block Height",
               "Block Density as a % of Fluid Density",
               "Percent of Block Submerged",
               "Height of Block Submerged"),
      Value = as.character(c(input$fluid.density,
                             input$block.density,
                             input$block.height,
                             (input$block.density/input$fluid.density),
                             (input$block.density/input$fluid.density),
                             ((input$block.density/input$fluid.density)*input$block.height))),
      stringsAsFactors = FALSE)
    
  })
  
  output$values <- renderTable({
    sliderValues()
  })
  
  output$blockPlot <- renderPlot({
    plot(c(100,200), c(-100,100), type = "n", xlab = "", ylab="",
         main = "block floating in liquid")
    abline(h = 0)
    rect(125,input$block.height-((input$block.density/input$fluid.density)*input$block.height),175,-((input$block.density/input$fluid.density)*input$block.height), density = 10, col = "blue")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
