# XenSCE

This package experimentally explores an
S4 class and methods for 10x Xenium demonstration data in Open Storage Network.

The package

- defines a class `XenSCE` that extends SingleCellExperiment, accommodating
geometry information for cells, nuclei, and transcripts in ParquetDataFrame or DataFrame instances

- includes functions to retrieve example data from NSF Open Storage Network buckets

- includes a small example `panc_sub` derived from [SFEData](https://bioconductor.org/packages/SFEData/) XeniumOutput

A view of the `panc_sub` XenSCE:

![](man/figures/pancsub.png)

Compare to the morphology_focus_0001.ome.tif found in the morphology_focus component of SFEData XeniumOutput

![](man/figures/img0001.png)
