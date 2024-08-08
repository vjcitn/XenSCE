#' mapping from ENSG to symbols based on EnsDb.Hsapiens.v79
#' @docType data
#' @format character()
#' @note named character vector with values gene symbols, name ENSG ids
#' @examples
#' data(e79sym)
#' head(e79sym)
"e79sym"

#' example XenSCE instance based on pancreas subset from SFEData XeniumOutput
#' @docType data
#' @format XenSCE
#' @examples
#' data(panc_sub)
#' head(panc_sub)
#' plot(panc_sub$x_centroid, panc_sub$y_centroid, pch="." , cex=1.5, xlab="x", ylab="y", main="cell centroids")
"panc_sub"
