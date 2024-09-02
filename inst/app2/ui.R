library(shiny)
library(ParquetDataFrame)
library(XenSCE)
library(SpatialExperiment)


if (!exists("xspep"))    xspep = restoreZipXenSPEP("prostInMem.zip")

what = "PROST"

  stopifnot(is(xspep, "XenSPEP"))
  rngs = apply(spatialCoords(xspep),2,function(x)round(range(x),0))
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
