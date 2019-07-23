############################
##                        ##
##  MINION DATA ANALYSIS  ##
##                        ##
############################

import os
from os import path

if not workflow.overwrite_configfile:
    configfile: "config.yml"

# workdir: path.join(config["workdir_top"], config["pipeline"])
workdir: config["workindDirectory"]

res = directory(config["resdir"])

rule all:
    input:
       both = expand("{res}/fast5_both", res = directory(config["resdir"])),
       single = expand("{res}/fast5_single", res = directory(config["resdir"])),
       classification_file = expand("{res}/classification", res = directory(config["resdir"])),
       fastq_merged = expand("{res}/merged.fastq", res = directory(config["resdir"])),
       fastq_dir = directory(expand("{res}/fastq", res = directory(config["resdir"]))),
       porechop_dir = directory(expand("{res}/porechop_out", res = directory(config["resdir"]))),
       trimmed_dir = directory(expand("{res}/fastq/trimmed", res = directory(config["resdir"])))


###### CLASSIFICATION ######

# Extracting sequences from multi FAST5 files to FAST5 files with single sequence.
rule deepbinner_classify:
    params:
       fastq = directory(config["fastq_dir"]),
       fast5 = directory(config["fast5_dir"])
    output:
       both = directory(expand("{res}/fast5_both", res = directory(config["resdir"]))),
       fastq_merged = expand("{res}/merged.fastq", res = directory(config["resdir"])),
       classification_file = expand("{res}/classification", res = directory(config["resdir"])),
       single = directory(expand("{res}/fast5_single", res = directory(config["resdir"])))
    conda: "envs/deepbinner_env.yml"
    threads: config["threads"]
    shell: """
       mkdir {output.both}
       echo "STEP 1.1 - Copy all (pass and fail) FAST5 files into one directory."
       find {params.fast5}/ -name \*.fast5 -exec cp {{}} {output.both}/ \;
       
       echo "STEP 1.2 - Merge all FASTQ sequences into one file."
       cat {params.fastq}/*.fastq > {output.fastq_merged}

       echo "STEP 2.1 - Multi directory to single."
       multi_to_single_fast5 -t {threads} -i {output.both} -s {output.single}

       echo "STEP 2.2 - Deepbinner classification."
       deepbinner classify --native {output.single} > {output.classification_file}
    """


###### BIN ######

rule deepbinner_bin:
    input:
       classification_file = expand("{res}/classification", res = directory(config["resdir"])),
       fastq_merged = expand("{res}/merged.fastq", res = directory(config["resdir"]))
    output:
       fastq_dir = directory(expand("{res}/fastq", res = directory(config["resdir"])))
    conda: "envs/deepbinner_env.yml"
    shell: """
       echo "STEP 4 - Deepbinner Bin."
       deepbinner bin --classes {input.classification_file} --reads {input.fastq_merged} --out_dir {output.fastq_dir}
    """

###### TRIM ######

rule porechop_trim:
    input:
       fastq_merged = expand("{res}/merged.fastq", res = directory(config["resdir"]))
    output:
       porechop_dir = directory(expand("{res}/porechop_out", res = directory(config["resdir"])))
       trimmed_dir = directory(expand("{res}/fastq/trimmed", res = directory(config["resdir"])))
    conda: "envs/deepbinner_env.yml"
    params:
       extra_end_trim = config["extra_end_trim"]
       fastq_dir = expand("{res}/fastq", res = directory(config["resdir"]))
    threads: config["threads"]
    shell: """
       echo "STEP 5.1 - Porechop run with two barcodes option."
       mkdir {output.trimmed_dir}
       porechop -i {input.fastq_merged} -b {output.porechop_dir} -t {threads} --require_two_barcodes --extra_end_trim {params.extra_end_trim}
       rm {output.porechop_dir}/none.*
       cat {output.porechop_dir}/*.fastq* > {output.trimmed_dir}/full_len.fastq
       rm {output.porechop_dir}/*.fastq*

       echo "STEP 5.2 - Porechop run for binned FASTQ files."
       
        for name in {params.fastq_dir}/barcode*
        do
           out_file=${{name##*/}};
           porechop -i $name -b {output.porechop_dir} -t {threads} --extra_end_trim {params.extra_end_trim}
           cat {output.porechop_dir}/*.fastq* > {output.trimmed_dir}/$out_file
        done
        rm -rf {output.porechop_dir}
    """

