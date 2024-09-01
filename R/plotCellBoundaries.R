namesInBox = function (xsce, xlim, ylim) 
{
    if (!requireNamespace("SpatialExperiment")) stop("install SpatialExperiment to use this function")
    cmat = SpatialExperiment::spatialCoords(xsce)
    xc = cmat[,"x_centroid"]
    yc = cmat[,"y_centroid"]
    inds = which(xc >= xlim[1] & xc <= xlim[2] & yc >= ylim[1] & 
        yc <= ylim[2])
    unique(colnames(xsce[, inds]))
}

bfeatsInBox = function (xsce, feat="cellbounds", xlim, ylim) 
{
    fb = slot(xsce, feat)
    xc = fb[,"vertex_x"]
    yc = fb[,"vertex_y"]
    inds = which(xc >= xlim[1] & xc <= xlim[2] & yc >= ylim[1] & 
        yc <= ylim[2])
    fb[inds,]
}

newbfinbx = function (xsce, feat = "cellbounds", xlim, ylim) 
{
#
# works with cbtab slot of XenSPEP
#
    fb = slot(xsce, feat)
    xc = fb[, "vertex_x"] 
    if (isFALSE(is(xc, "numeric"))) xc = xc |> dplyr::collect() |> unlist() |> as.numeric()
    yc = fb[, "vertex_y"] 
    if (isFALSE(is(yc, "numeric"))) yc = yc |> dplyr::collect() |> unlist() |> as.numeric()
    fb[xc >= xlim[1] & xc <= xlim[2] & yc >= ylim[1] & 
        yc <= ylim[2],]
}


txfeatsInBox = function (xsce, feat="transcripts", xlim, ylim)  # may have colname x or x_location etc.
{
    fb = slot(xsce, feat)
    nms = names(fb)
    if ("x" %in% nms) use = c(x="x", y="y")
    if ("x_location" %in% nms) use = c(x="x_location", y="y_location")
    xc = fb[,use["x"]]
    yc = fb[,use["y"]]
    inds = which(xc >= xlim[1] & xc <= xlim[2] & yc >= ylim[1] & 
        yc <= ylim[2])
    fb[inds,]
}

#' restrict XenSCE to cells with centroids in specified rectangle,
#' also restrict boundary and transcript location features
#' @param xsce XenSCE instance
#' @param xlim numeric(2)
#' @param ylim numeric(2)
#' @export
clip_rect = function(xsce, xlim, ylim) {
  nn = namesInBox(xsce, xlim, ylim)
  stopifnot(length(nn)>0)
  ini = xsce[, nn]
  cb = bfeatsInBox(ini, xlim=xlim, ylim=ylim)
  nb = bfeatsInBox(ini, "nucbounds", xlim, ylim)
  tloc = txfeatsInBox(ini, "transcripts", xlim, ylim)
  slot(ini, "cellbounds") = cb
  slot(ini, "nucbounds") = nb
  slot(ini, "transcripts") = tloc
  ini
}

#' render boundaries of cells with optional centroid positions and transcript positions
#' @importFrom graphics points polygon
#' @param xsce XenSCE instance
#' @param add_cent logical(1)
#' @param cent_col character(1) default to "red"
#' @param cent_cex numeric(1) default to 0.2
#' @param add_tx logical(1)
#' @param tx_cex numeric(1)
#' @examples
#' dem = build_panc_subset()
#' plotCellBoundaries(clip_rect(dem, xlim=c(600,850), ylim=c(500,750)))
#' @export
plotCellBoundaries = function(xsce, add_cent=TRUE, cent_col="red", cent_cex=.2, add_tx=TRUE,
   tx_cex=.1) {
  bb = getCellBoundaries(xsce)
  bb = bb[as(bb$cell_id, "character") %in% colnames(xsce),]
  xlim = range(bb$vertex_x)
  ylim = range(bb$vertex_y)
  plot(min(xlim), min(ylim), pch=" ", xlim=xlim, ylim=ylim, xlab="x", ylab="y")
  bid = as.character(bb$cell_id)
  sbb = split(as(bb, "data.frame"), bid)
  for (i in seq_len(length(sbb))) polygon(sbb[[i]]$vertex_x, sbb[[i]]$vertex_y)
  if (add_cent) points(xsce$x_centroid, xsce$y_centroid, cex=cent_cex, col=cent_col)
  if (add_tx) points(getTranscripts(xsce)$x_location, getTranscripts(xsce)$y_location, cex=tx_cex)
  invisible(NULL)
}

#library(XenSCE)
#x = build_panc_subset()
#plotCellBoundaries(clip_rect(x, xlim=c(200,450), ylim=c(800,1000)))
