library(shiny)

shinyUI(fluidPage(
  headerPanel("Principal Components Analysis"),
  sidebarLayout(position='left',
    sidebarPanel(
      h4("The Original Image"),
      img(src='lena.jpg',height=256,width=256),
      h3(""),
      sliderInput('var',
                 strong('Select the number of Principal Components'), 
                 min = 1,
                 max= 512,
                 value = 5,
                 animate= FALSE)
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Image", plotOutput('compress')), 
                  tabPanel("Variance",plotOutput('variance')),
                  tabPanel("PCA",plotOutput('pca')),
                  tabPanel("Data",
                           h5("Image Size"),
                           verbatimTextOutput('dim'),
                           #h5("Data summary"),
                           #verbatimTextOutput("summary"),                                                  
                           sliderInput('col',
                                       strong("select the number of columns of data to view"),
                                       min = 1,
                                       max =512,
                                       value = c(1,10)),
                           dataTableOutput(outputId='view')
                                                
                           #tableOutput("view")
                  )
         
      )
    ) 
  )
))