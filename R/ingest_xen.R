setOldClass("ArrowTabular")
setOldClass("arrow_dplyr_query")
setOldClass("Table")
setClassUnion("ArrowTabOrNULL", c("Table", "ArrowTabular", "arrow_dplyr_query", "NULL"))
#library(SpatialExperiment)


#' manage SpatialExperiment with parquet references
#' @importClassesFrom SpatialExperiment SpatialExperiment
#' @note Trying to be lighter weight than XenSCE that uses DelayedArray in ParquetDataFrame.
#' @export
setClass("XenSPEP", contains="SpatialExperiment",  # spatial expt with parquet refs
    representation(cellbounds_path="character",
                   nucbounds_path="character",
                   tx_path="character", loaded="logical",
                   cbtab="ArrowTabOrNULL", nbtab="ArrowTabOrNULL",
                      txtab="ArrowTabOrNULL" ))

#' display aspects of XenSPEP
#' @importFrom methods callNextMethod new slot
#' @param object instance of XenSCE
#' @export
setMethod("show", "XenSPEP", function(object) {
  cat("XenSPEP instance.  SCEcomponent:\n")
  show(as(object, "SingleCellExperiment"))
  cat("use spatialCoords() for cell centroids.\n")
  if (!slot(object, "loaded")) {
       cat("Geometry element paths (not loaded):\n")
       cat(sprintf(" %s\n %s\n %s\n", slot(object, "cellbounds_path"),
                   slot(object, "nucbounds_path"),
                   slot(object, "tx_path"))) 
     }
  else {
      cat("Geometry elements loaded.\n")
       }
} )

#' formal bracket definition, that leaves parquet geometry information alone.
#' @param x instance of XenSPEP
#' @param i feature selection
#' @param j cell selection
#' @param \dots passed to SpatialExperiment methods
#' @param drop logical(1)
#' @note Gives a message and calls callNextMethod.
#' @export
setMethod("[", c("XenSPEP"), function (x, i, j, ..., drop = TRUE) {
#  if (!missing(i)) stop("method not defined")
#  if (!missing(j)) {
#     co = SpatialExperiment::spatialCoords(x)
#     rngs = apply(co, 2, range)
#     x@cbtab = x@cbtab |> dplyr::filter(vertex_x > rngs[1,1] & vertex_x < rngs[2,1] &
#           vertex_y > rngs[1,2] & vertex_y < rngs[2,2])
#     x@nbtab = x@nbtab |> dplyr::filter(vertex_x > rngs[1,1] & vertex_x < rngs[2,1] &
#           vertex_y > rngs[1,2] & vertex_y < rngs[2,2])
#     x@txtab = x@txtab |> dplyr::filter(x_location > rngs[1,1] & x_location < rngs[2,1] &
#           y_location > rngs[1,2] & y_location < rngs[2,2])
#     }
     message("Parquet geometry data untouched by subsetting.  Affects SpatialExperiment content only")
     callNextMethod()
   })
     



setValidity("XenSPEP", function(object) {
 cb = arrow::read_parquet(object@cellbounds_path)
 nb = arrow::read_parquet(object@nucbounds_path)
 tx = arrow::read_parquet(object@tx_path)
 if (!(all(c("vertex_x", "vertex_y") %in% names(cb)))) return(sprintf("'vertex_x' or 'vertex_y' absent from %s", object@cellbounds_path))
 if (!(all(c("vertex_x", "vertex_y") %in% names(nb)))) return(sprintf("'vertex_x' or 'vertex_y' absent from %s", object@nucbounds_path))
 if (!(all(c("x_location", "y_location", "z_location") %in% names(tx)))) return(sprintf("'x_location' or 'y_location' or 'z_location' absent from %s", object@nucbounds_path))
 TRUE
 })

#' produce a pre-loaded XenSPEP (SpatialExperiment with parquet references)
#' @param folder character(1) 'standard' Xenium output folder
#' @export
ingest_xen = function(folder) {
  stopifnot(file.exists(cfmpath <- file.path(folder, "cell_feature_matrix.tar.gz")))
  stopifnot(file.exists(cmetapath <- file.path(folder, "cells.parquet")))
  stopifnot(file.exists(cbpath <- file.path(folder, "cell_boundaries.parquet")))
  stopifnot(file.exists(nbpath <- file.path(folder, "nucleus_boundaries.parquet")))
  stopifnot(file.exists(txpath <- file.path(folder, "transcripts.parquet")))
  txf = TENxIO::TENxFile(cfmpath)
  sce = TENxIO::import(txf) # SCE with dgCMatrix for assay
  cmeta = arrow::read_parquet("cells.parquet") 
  cd = as.data.frame(cmeta)
  stopifnot(all(c("x_centroid", "y_centroid") %in% names(cd)))
  rownames(cd) = cd[,1]
  cd = S4Vectors::DataFrame(cd)
  colData(sce) = cd
  spe = as(sce, "SpatialExperiment") # propagates assayNames
  SpatialExperiment::spatialCoords(spe) = data.matrix(cd[,c("x_centroid", "y_centroid")])
  cb = arrow::read_parquet(cbpath)
  obj = new("XenSPEP", spe, cellbounds_path=file.path(folder, "cell_boundaries.parquet"),
       nucbounds_path=file.path(folder, "nucleus_boundaries.parquet"), 
       tx_path=file.path(folder, "transcripts.parquet"),
       loaded=FALSE) 
  #list(spe=spe, cb=cb, obj=obj)
  obj
}

#' read and bind parquet data to XenSPEP
#' @param x instance of XenSPEP
#' @export
setGeneric("loadGeometry", function(x) standardGeneric("loadGeometry"))
#' read and bind parquet data to XenSPEP
#' @param x instance of XenSPEP
#' @export
setMethod("loadGeometry", "XenSPEP", function(x) {
  slot(x, "cbtab") = arrow::read_parquet(slot(x, "cellbounds_path"), as_data_frame=FALSE)
  slot(x, "nbtab") = arrow::read_parquet(slot(x, "nucbounds_path"), as_data_frame=FALSE)
  slot(x, "txtab") = arrow::read_parquet(slot(x, "tx_path"), as_data_frame=FALSE)
  slot(x, "loaded") = TRUE
  x
  })

#' XenSPEP (SpatialExperiment with parquet references) constructor
#' @param folder character(1) 'standard' Xenium output folder
#' @export
XenSPEP = function(folder) {
  stopifnot(file.exists(cfmpath <- file.path(folder, "cell_feature_matrix.tar.gz")))
  stopifnot(file.exists(cmetapath <- file.path(folder, "cells.parquet")))
  stopifnot(file.exists(cbpath <- file.path(folder, "cell_boundaries.parquet")))
  stopifnot(file.exists(nbpath <- file.path(folder, "nucleus_boundaries.parquet")))
  stopifnot(file.exists(txpath <- file.path(folder, "transcripts.parquet")))
  txf = TENxIO::TENxFile(cfmpath)
  sce = TENxIO::import(txf) # SCE with dgCMatrix for assay
  cmeta = arrow::read_parquet("cells.parquet") 
  cd = as.data.frame(cmeta)
  stopifnot(all(c("x_centroid", "y_centroid") %in% names(cd)))
  rownames(cd) = cd[,1]
  cd = S4Vectors::DataFrame(cd)
  colData(sce) = cd
  spe = as(sce, "SpatialExperiment") # propagates assayNames
  SpatialExperiment::spatialCoords(spe) = data.matrix(cd[,c("x_centroid", "y_centroid")])
  cb = arrow::read_parquet(cbpath)
  new("XenSPEP", spe, cellbounds_path=file.path(folder, "cell_boundaries.parquet"),
       nucbounds_path=file.path(folder, "nucleus_boundaries.parquet"), 
       tx_path=file.path(folder, "transcripts.parquet"),
       loaded=TRUE, cbtab = arrow::read_parquet("cell_boundaries.parquet", as_data_frame=FALSE),
       nbtab = arrow::read_parquet("nucleus_boundaries.parquet", as_data_frame=FALSE),
       txtab = arrow::read_parquet("transcripts.parquet", as_data_frame=FALSE))
}
