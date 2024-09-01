library(shiny)
library(ParquetDataFrame)
library(XenSCE)
library(SpatialExperiment)

#if (!exists("gbm")) load("gbm.rda")

    pa = cache_xen_luad()
    luad = restoreZipXenSPEP(pa)

rngs = apply(spatialCoords(luad),2,range)
xmid = mean(rngs[,"x_centroid"])
ymid = mean(rngs[,"y_centroid"])



ui = fluidPage(
 sidebarLayout(
  sidebarPanel(
   helpText("view gbm"),
   sliderInput("xstart", "xstart", min=rngs[1,"x_centroid"], max=rngs[2,"x_centroid"], step=50, value=xmid),
   sliderInput("ystart", "ystart", min=rngs[1,"y_centroid"], max=rngs[2,"y_centroid"], step=50, value=ymid),
   sliderInput("width", "width", min=200, max=2000, step=100, value=400),
   actionButton("go", "go", class="btn-success")
   ),
  mainPanel(
   tabsetPanel(
    tabPanel("cells", plotOutput("cells", height="600px", width="600px"))
   )
  )
 )
)

server = function(input, output) {
 output$cells = renderPlot({
  input$go
  view_seg(luad, c(input$xstart, input$xstart+input$width), c(input$ystart, input$ystart+input$width))
  })
}
