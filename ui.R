library(shiny)

shinyUI(fluidPage(
  headerPanel("Principal Components Analysis"),
  sidebarLayout(position='left',
    sidebarPanel(
      helpText("Principal component analysis (PCA) is a statistical procedure that  provides a sequence of best linear approximations to a given high-dimensional observation. This PCA application takes a classic image (lena) in image processing as an example to illustrate the dimension reduction."),          
      h4("The Original Image"),
      img(src='lena.jpg',height=256,width=256),
      h3(""),
      sliderInput('var',
                 strong('Select the number of Principal Components'), 
                 min = 1,
                 max= 512,
                 value = 5,
                 animate= FALSE),
      helpText("Note: the principal components are ordered in such a way that the first principal component explains the highest variance in the data and the succeeding compoent accounts for less variance than the preceeding one but highest variance in the rest of the data.")
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Image", 
                           plotOutput('compress'),
                           helpText("The left image is produced using the first n principal components, and you will see that the higher n is, the clearer the image is. The right figure shows the percentage of variance explained by the first n principal components. Note that the first 31 principal components account for 90% of the variance and the resulted right image acquires most characters of the original image")), 
                  tabPanel("Variance",
                           plotOutput('variance'),
                           helpText("The variance figure shows that the principal components are ordered in such a way that the variance each of the components explains is decreasing. Note that the variance decreases sharply for the first 10 principal components, and each of the rest principal components explains less than 1% of the variance.")),
                  tabPanel("PCA",
                           plotOutput('pca'),
                           helpText("The PCA figure illustrates that each principal component is a linear combination of the original variabes (the columns). Note that principal component that accounts for <1% of the variance seems a random combination of the original variables.")),
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