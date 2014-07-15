library(shiny)
library(jpeg)
library(ggplot2)
library(reshape)

lena = readJPEG('lena.jpg')
sc <- scale(lena)
svd1 <-svd(sc)

shinyServer(
  function(input, output) {
        
    output$compress <- renderPlot({
      pcaNo <- input$var
      approx <- svd1$u[,1:pcaNo] %*% diag(svd1$d[1:pcaNo],nrow=pcaNo,ncol=pcaNo)%*% t(svd1$v[,1:pcaNo])
      
      for (icol in 1:ncol(approx)) {
        approx[,icol]=approx[,icol]*attr(sc,'scaled:scale')[icol]+attr(sc,'scaled:center')[icol]
      }
      
      ratioV = cumsum(svd1$d^2/sum(svd1$d^2))[pcaNo]*100
      ratioV = round(ratioV,2)
      par(pty='s',mar=c(2,4,4,2),bg='white',mfrow =c(1,2))
      image(t(approx)[,nrow(approx):1],,col=grey(seq(0,1,length=256)),xaxt='n',yaxt='n',asp=1,main=paste("Image Using the First \n",bquote(.(pcaNo)), "Principal Components"))
      plot(cumsum(svd1$d^2/sum(svd1$d^2)),
           pch=19,
           xlab="Principal components (512 in Total)",
           ylab="% Variance explained",
           main=paste0('The First ',
                      bquote(.(pcaNo)),
                      ' Principal Components \n account for ',
                      bquote(.(ratioV)),
                      '% variance')
      )
      abline(h=ratioV/100,col='green',lwd=2)
      
    })
    output$variance <- renderPlot({
      ratioV1 = (svd1$d[input$var])^2/sum(svd1$d^2)*100
      ratioV1 = round(ratioV1,6)
      plot(svd1$d^2/sum(svd1$d^2),
           pch=19,
           xlab="Principal components (512 in Total)",
           ylab="% Variance explained by each component"           
      )
      
      title(paste0('No.',
                   bquote(.(input$var)),
                   ' Principal Component \n accounts for ',
                   bquote(.(ratioV1)),
                   '% variance'))
      abline(v=input$var,col='green',lwd=2)
    })
    
    output$pca <-renderPlot({
      pcadata <-data.frame(id=1:512,v1=svd1$v[,input$var])
      plot(pcadata$id,pcadata$v1,
           col = 'green',
           xlab = 'Original columns',
           ylab ='Coefficients',
           main = paste0('No.',bquote(.(input$var)),
                         ' Principal Component \n is an linear combination of the original columns')
      )
         
      #ggplot(pcadata,aes(x=id,y=v1))+geom_point()
      #pcadata <- melt(pcadata,id='id')
      #ggplot(data=pcadata,aes(x=id,y=value,group =variable,colour=variable))+geom_point()
    })
    
    output$dim <- renderPrint ({
      dim(lena)      
    })
    
    output$summary <- renderPrint ({
      summary(as.vector(lena))
    })
    
    output$view <-renderDataTable({
      #as.data.frame(lena[,1:10])
      lenadf <- as.data.frame(lena)
      lenadf[,input$col[1]:input$col[2]]      
      #lena[,1:5]
    },options = list(aLengthMenu=c(5,10),iDisplayLength=5))
    
  }
  
)