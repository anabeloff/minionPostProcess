
Pipeline for miniON data demultiplexing and trimming
====================================================

The pipeline uses [SnakeMake](https://snakemake.readthedocs.io/en/stable/index.html) (version 5+) to run [DeepBinner](https://github.com/rrwick/Deepbinner) to classify and bin FASTQ reads and [PoreChop](https://github.com/rrwick/Porechop) to trimm barecodes. Additionally classification with Deepbinned requires [multi_to_single_fast5](https://github.com/nanoporetech/ont_fast5_api) from Nanopore toolkit.  

## Dependencies

First install Snakemake with conda or pip.  

```
conda install -c bioconda -c conda-forge snakemake
```

Install TensorFlow.  
It is a main dependancy of Deepbinner. If you using CPU (no GPU support) install only via `pip`.  
```
# If you working in Python 3+ environment use pip, it is the same as pip3
pip3 install tensorflow
```
Install Deepbinner from Github sourse.
```
pip3 install git+https://github.com/rrwick/Deepbinner.git
```

Install Nanopore tool kit.
```
pip install ont-fast5-api
```

Install Porechop.
```
pip3 install git+https://github.com/rrwick/Porechop.git
```

## Usage

To start the pipilene issue following command:
```
snakemake -s Snakefile
```

Here you need to provide a path to a `Snakefile`. Configuration file `config.yml` must be in the same directory with `Snakefile`. Alternatively you can issue a command `snakemake -s Snakefile --configfile /path/to/config.yml` providing a path to configuration file.  

#### INPUT
Before you launch edit `config.yml` 

 - `workindDirectory` - ABSOLUTE path to a working directory.
 - `fast5_dir` - Directory name with FAST5 files. MUST be inside working directory.
 - `fastq_dir` - Directory name with FASTQ files, output after basecalling (with Guppy).  MUST be inside working directory.
 - `extra_end_trim` - Porechop option. Number of bases to trim after adapter sequence. Porechop default 2.
 - `threads` - Number of cores.

#### OUTPUT
The pipeline outputs following directories:

 - `fastq` - Contains Deepbinned binned FASTQ files by barcode.
 - `fastq_trimmed` - Contains timmed by Porechop barcoded files.

File outputs:

 - `classification` - Deepbinner classification of FAST5 files.
 - `full_len.fastq` - File contains Porechop trimmed sequences that have barcodes on both ends. Full length sequences (useful for RNA-seq).
 - `merged.fastq` - Input FASTQ files merged into one file.



