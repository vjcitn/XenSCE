library(shiny)
library(ParquetDataFrame)
library(XenSCE)
library(SpatialExperiment)

#if (!exists("gbm")) load("gbm.rda")

if (!exists("xspep"))    xspep = restoreZipXenSPEP("luad2.zip")
what = "LUAD"

  stopifnot(is(xspep, "XenSPEP"))
  rngs = apply(spatialCoords(xspep),2,range)
  xmid = mean(rngs[,"x_centroid"])
  ymid = mean(rngs[,"y_centroid"])
  
  
  server = function(input, output) {
   output$cells = renderPlot({
    input$go
    view_seg(xspep, c(input$xstart, input$xstart+input$width), c(input$ystart, input$ystart+input$width))
    })
   output$map = renderPlot({
    plot(SpatialExperiment::spatialCoords(xspep), pch=".", cex=.5)
    pmat = rbind(c(input$xstart, input$ystart), c(input$xstart, input$ystart+input$width),
             c(input$xstart+input$width, input$ystart+input$width), c(input$xstart+input$width, input$ystart))
    polygon(pmat, col="white", lwd=2, density=0)
    })
   output$showx = renderPrint({
    print(xspep)
    })
   output$topbox = renderUI({
      helpText(sprintf("view %s", what))
    })
  }
  
