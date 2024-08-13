#' cache and/or retrieve an ome.tif file for demonstration 
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
