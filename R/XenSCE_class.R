
#' define container for Xenium demo data
#' @export
setClass("XenSCE", contains="SingleCellExperiment", slots=c(cellbounds="DataFrame",
  transcripts="DataFrame", nucbounds="DataFrame"))

#' summarize XenSCE
#' @importFrom methods callNextMethod new slot
#' @param object instance of XenSCE
#' @export
setMethod("show", "XenSCE", function(object) {
  callNextMethod(); 
  cat("Parquet elements:\n")
  print(xdims(object)) 
} )


#' helper function for XenSCE show method, producing dimensions for
#' geometry information
#' @param x instance of XenSCE
xdims = function (x) 
{
    ans = sapply(c("transcripts", "cellbounds", "nucbounds"), 
        function(z) dim(slot(x, z)))
    ans = t(ans)
    colnames(ans) = c("nrow", "ncol")
    data.frame(ans)
}

#' method for transcript extraction
#' @param x instance of XenSCE
#' @export
setGeneric("getTranscripts", function(x) standardGeneric("getTranscripts"))
#' method for transcript extraction
#' @param x instance of XenSCE
#' @export
setMethod("getTranscripts", "XenSCE", function(x) slot(x, "transcripts"))

#' method for cell boundary extraction
#' @param x instance of XenSCE
#' @export
setGeneric("getCellBoundaries", function(x) standardGeneric("getCellBoundaries"))
#' method for cell boundary extraction
#' @param x instance of XenSCE
#' @export
setMethod("getCellBoundaries", "XenSCE", function(x) slot(x, "cellbounds"))

#' method for nucleus boundary extraction
#' @param x instance of XenSCE
#' @export
setGeneric("getNucleusBoundaries", function(x) standardGeneric("getNucleusBoundaries"))
#' method for nucleus boundary extraction
#' @param x instance of XenSCE
#' @export
setMethod("getNucleusBoundaries", "XenSCE", function(x) slot(x, "nucbounds"))
