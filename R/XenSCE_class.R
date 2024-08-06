
#' define container for Xenium demo data
#' @export
setClass("XenSCE", contains="SingleCellExperiment", slots=c(cellbounds="ParquetDataFrame",
  transcripts="ParquetDataFrame", nucbounds="ParquetDataFrame"))

#' summarize XenSCE
#' @export
setMethod("show", "XenSCE", function(object) {
  callNextMethod(); 
  cat("Parquet elements:\n")
  print(xdims(object)) 
} )


#' helper function for XenSCE show method
xdims = function (x) 
{
    ans = sapply(c("transcripts", "cellbounds", "nucbounds"), 
        function(z) dim(slot(x, z)))
    ans = t(ans)
    colnames(ans) = c("nrow", "ncol")
    data.frame(ans)
}

#' method for transcript extraction
#' @export
setGeneric("getTranscripts", function(x) standardGeneric("getTranscripts"))
setMethod("getTranscripts", "XenSCE", function(x) slot(x, "transcripts"))

#' method for cell boundary extraction
#' @export
setGeneric("getCellBoundaries", function(x) standardGeneric("getCellBoundaries"))
setMethod("getCellBoundaries", "XenSCE", function(x) slot(x, "cellbounds"))

#' method for nucleus boundary extraction
#' @export
setGeneric("getNucleusBoundaries", function(x) standardGeneric("getNucleusBoundaries"))
setMethod("getNucleusBoundaries", "XenSCE", function(x) slot(x, "nucbounds"))
