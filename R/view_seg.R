
#' naive polygon viewer
#' @param x instance of XenSCE
#' @param xlim numeric(2) ordered vector of max and min on x 
#' @param ylim numeric(2) ordered vector of max and min on y
#' @param \dots passed to polygon()
#' @examples
#' gbm = build_demo()
#' out = view_seg(gbm, c(5800, 6500), c(6300, 7000), lwd=.5, col="lightgray")
#' out$ncells
#' @export
view_seg = function(x, xlim, ylim, ...) {
  cc = match.call()
  if (!requireNamespace("SpatialExperiment")) stop("install SpatialExperiment to use this function.")
  ppdf = data.frame(SpatialExperiment::spatialCoords(x))
  rngs = sapply(ppdf[, c("x_centroid", "y_centroid")], range)
#  stopifnot(rngs
  cb = getCellBoundaries(x)
  cb2 = cb[cb$vertex_x > xlim[1] & cb$vertex_x < xlim[2] & cb$vertex_y > ylim[1] & cb$vertex_y < ylim[2],]
  cb2w = as.data.frame(cb2)
  scb2w = split(cb2w, cb2w$cell_id)
  ncells = length(scb2w)
  rngs = sapply(cb2w[,c("vertex_x", "vertex_y")], range)
  plot(rngs[1,1], rngs[1,2], xlim=rngs[,1], ylim=rngs[,2], xlab="x", ylab="y", pch = " ")
  zz = lapply(scb2w, function(x, ...) polygon(x$vertex_x, x$vertex_y, ...), ...)
#scb2w[[1]]
#head(scb2w[[1]])
#lapply(scb2w, function(x) polygon(x$vertex_x, x$vertex_y, ...))
#savehistory(file="lkpoly.hist.txt")
  invisible(list(polys = zz, ncells=ncells, call=cc))
}
