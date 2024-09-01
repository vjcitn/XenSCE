library(shiny)
library(ParquetDataFrame)
library(XenSCE)
library(SpatialExperiment)

#if (!exists("gbm")) load("gbm.rda")

    pa = cache_xen_luad()
if (!exists("luad"))    luad = restoreZipXenSPEP(pa)

explore = function(xspep, what="unknown") {
  stopifnot(is(xspep, "XenSPEP"))
  rngs = apply(spatialCoords(xspep),2,function(x) round(range(x),0))
  xmid = round(mean(rngs[,"x_centroid"]),0)
  ymid = round(mean(rngs[,"y_centroid"]),0)
  
  ui = fluidPage(
   sidebarLayout(
    sidebarPanel(
     uiOutput("topbox"),
     sliderInput("xstart", "xstart", min=rngs[1,"x_centroid"], max=rngs[2,"x_centroid"], step=50, value=xmid),
     sliderInput("ystart", "ystart", min=rngs[1,"y_centroid"], max=rngs[2,"y_centroid"], step=50, value=ymid),
     sliderInput("width", "width", min=200, max=3000, step=100, value=400)#,
#     actionButton("go", "go", class="btn-success")
     ),
    mainPanel(
     tabsetPanel(
      tabPanel("cells", plotOutput("cells", height="600px", width="600px")),
      tabPanel("map", plotOutput("map", height="600px", width="600px")),
      tabPanel("about", verbatimTextOutput("showx"))
     )
    )
   )
  )
  
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
  
  runApp(list(ui=ui, server=server))
}
