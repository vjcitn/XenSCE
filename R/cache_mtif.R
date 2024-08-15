#' cache and/or retrieve path to an ome.tif file for demonstration 
#' @param cache defaults to BiocFileCache::BiocFileCache()
#' @param url location where tiff file can be retrieved
#' @export
cache_mtif = function(cache=BiocFileCache::BiocFileCache(), 
   url="https://mghp.osn.xsede.org/bir190004-bucket01/BiocXenData/morphology_focus_0001.ome.tif") {
 chk = bfcquery(cache, "BiocXenData/morphology_focus_0001.ome.tif")
 n = nrow(chk)
 if (n>=1) return(chk[n,]$rpath)
 bfcadd(cache, rname=basename(url), fpath=url, action="copy", download=TRUE)
}

#' cache and/or retrieve path to an SFE of V1 lung demo data from 10x
#' @param cache defaults to BiocFileCache::BiocFileCache()
#' @param url location where zip file can be retrieved
#' @note Lacks transcript coordinates
cache_sfeLung_ntx = function(cache=BiocFileCache::BiocFileCache(), 
   url="https://mghp.osn.xsede.org/bir190004-bucket01/BiocXenData/sfeLung.zip") {
 chk = bfcquery(cache, "BiocXenData/sfeLung.zip")
 n = nrow(chk)
 if (n>=1) return(chk[n,]$rpath)
 bfcadd(cache, rname=basename(url), fpath=url, action="copy", download=TRUE)
}

#' cache and/or retrieve path to an SFE of V1 lung demo data from 10x
#' @param cache defaults to BiocFileCache::BiocFileCache()
#' @param url location where zip file can be retrieved
#' @note We are explicitly avoiding declaring reliance on terra
#' or SpatialFeatureExperiment, to keep package weight low.
#' Thus the example will fail unless these are already present.
#' @examples
#' if (!requireNamespace("terra")) {
#'   message("install terra package to run this example")
#'   } else if (!requireNamespace("SpatialFeatureExperiment")) {
#'   message("install SpatialFeatureExperiment package to run this example")
#'   } else {
#'   zp = cache_sfeLung()
#'   td = tempdir()
#'   unzip(zp, exdir=td)
#'   ans = HDF5Array::loadHDF5SummarizedExperiment(file.path(td, "lungSFEtxg"))
#'   SpatialFeatureExperiment::show(ans)
#'   }
#' @export
cache_sfeLung = function(cache=BiocFileCache::BiocFileCache(), 
   url="https://mghp.osn.xsede.org/bir190004-bucket01/BiocXenData/lungSFEtxg.zip") {
 chk = bfcquery(cache, "BiocXenData/lungSFEtxg.zip")
 n = nrow(chk)
 if (n>=1) return(chk[n,]$rpath)
 bfcadd(cache, rname=basename(url), fpath=url, action="copy", download=TRUE)
}

