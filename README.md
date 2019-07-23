
Pipeline for miniON data demultiplexing and trimming
====================================================

The pipeline uses [SnakeMake](https://snakemake.readthedocs.io/en/stable/index.html) to run [DeepBinner](https://github.com/rrwick/Deepbinner) to classify and bin FASTQ reads and [PoreChop](https://github.com/rrwick/Porechop) to trimm barecodes. Additionally classification with Deepbinned requires [multi_to_single_fast5](https://github.com/nanoporetech/ont_fast5_api) from Nanopore.  

Current version does not include Porechop trim. It will be added later.

## Dependencies

First install Snakemake with conda or pip. Remember that other dependacies work only with pip.

```
conda install -c bioconda -c conda-forge snakemake
```

Install TensorFlow.  
It is a main dependancy of Deepbinner.
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



