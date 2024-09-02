Data collected 19 August 2024

https://cf.10xgenomics.com/samples/xenium/3.0.0/Xenium_Prime_Human_Skin_FFPE/Xenium_Prime_Human_Skin_FFPE_outs.zip

Use 0.0.7 of XenSCE from github.com/vjcitn

xen_sk is a folder that can be restored with HDF5Array::loadHDF5SummarizedExperiment

sk_spe = loadHDF5SummarizedExperiment("xen_sk")

skg = loadGeometry(sk_spe) # will succeed if the parquet files are in the working folder.
