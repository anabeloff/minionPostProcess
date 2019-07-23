
Pipeline for miniON data demultiplexing and trimming
====================================================

The pipeline uses [SnakeMake](https://snakemake.readthedocs.io/en/stable/index.html) to run [DeepBinner](https://github.com/rrwick/Deepbinner) to classify and bin FASTQ reads and [PoreChop](https://github.com/rrwick/Porechop) to trimm barecodes. Additionally classification with Deepbinned requires [multi_to_single_fast5](https://github.com/nanoporetech/ont_fast5_api) from Nanopore.  
All tools will be installed in the Conda environment provided with the pipeline.


Before you start
================

It is recommended to run Snakemake to create Conda environment first.  
```

```
