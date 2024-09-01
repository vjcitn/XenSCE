#' serialize the collection of XenSPEP and parquet with zip
#' @param xsp instance of XenSPEP with geometry loaded
#' @param targetfile character(1) destination of zip process
#' @note a .rds and three parquet files are zipped together for restoration
#' by `restoreZipXenSPEP`
#' @export
zipXenSPEP = function(xsp, targetfile) {
  stopifnot(is(xsp, "XenSPEP"))
  stopifnot(isTRUE(slot(xsp, "loaded")))
  pas = unlist(lapply(c("cellbounds_path", "nucbounds_path", "tx_path"),
      function(x) slot(xsp, x)))
  rdstarg = paste0(basename(tempfile()), ".rds")
  saveRDS(xsp, file=rdstarg)
  zip(targetfile, c(rdstarg, pas))
}

#' use unzip, readRDS, and loadGeometry to restore a XenSPEP
#' @param zipf character(1) path to zip file created with `zipXenSPEP`
#' @return instance of XenSPEP
#' @export
restoreZipXenSPEP = function(zipf) {
  fns = unzip(zipf, list=TRUE)
  toread = grep("rds$", fns$Name, value=TRUE)
  unzip(zipf)
  ans = readRDS(toread)
  loadGeometry(ans)
}
