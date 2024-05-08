nextcloudcmd \
  --user solymosi --password "fu?;#9VsY4F<mWj3>G.7/M" --exclude /data/sn/vietnam/exclude.lst \
  /data/sn/vietnam \
  https://91.83.105.2:8080/

mkdir raw
mv FR*/*.gz raw
rm -rf FR*

export PATH=/data/tools/TrimGalore-0.6.7:$PATH
export PATH=/data/tools/FastQC:$PATH

cd /data/sn/vietnam/20240313/raw
mkdir qc
for f in *.gz
do
  fastqc -o qc -t 60 $f
done

export PATH=/data/tools/miniforge3/bin:$PATH
source activate cutadapt
for f in *_R1_001.fastq.gz
do
  trim_galore --cores 8 \
    --dont_gzip \
    --quality 20 \
    --length 50 \
    --paired $f ${f/'_R1_001.fastq.gz'/'_R2_001.fastq.gz'}
done

# for f in *_val_1.fq
# do
#   IFS='_' read -r id string <<< "$f"
#   cat $f | awk -v fqname=$id  '{print (NR%4 == 1) ? "@"fqname"_" ++i : $0}' > $id'_1.fq'
# done
#
# for f in *_val_2.fq
# do
#   IFS='_' read -r id string <<< "$f"
#   cat $f | awk -v fqname=$id  '{print (NR%4 == 1) ? "@"fqname"_" ++i : $0}' > $id'_2.fq'
# done

# https://github.com/DerrickWood/kraken2/issues/87
# k2 classify --threads 60 --db $db --paired --output x.krk FR8_1.fq FR9_1.fq FR8_2.fq FR9_2.fq
#


export PATH=/data/tools/kraken2-2.1.3:$PATH

db=/data/tools/kraken2-2.1.3/nt

for f in *_R1_001_val_1.fq
do
  rpt=${f/'_R1_001_val_1.fq'/'.rpt'}
  out=${f/'_R1_001_val_1.fq'/'.kraken'}
  kraken2 --threads 50 --db $db --report $rpt --output $out --paired $f ${f/'_R1_001_val_1.fq'/'_R2_001_val_2.fq'}
done


kraken-biom *.rpt --fmt json -o vietnam02_nt.biom

# R
library(phyloseq)
library(microbiome)
library(tidyverse)
library(psadd)

dat = import_biom('vietnam02_nt.biom', parseFunction=parse_taxonomy_greengenes)

sd = data.frame(SampleID=colnames(otu_table(dat)))
rownames(sd) = sd$SampleID
sample_data(dat) = sd
plot_krona(dat, 'vietnam02_nt', 'SampleID', trim=T)



export PATH=/data/tools/megahit/build:$PATH

for f in *_R1_001_val_1.fq
do
  r=${f/'_R1_001_val_1.fq'/'_R2_001_val_2.fq'}
  o=${f/'_R1_001_val_1.fq'/''}
  d="megahit_"$o
  if [ ! -d $d ]
  then
    megahit -t 50 -1 $f -2 $r -o $d
  fi
done


export PATH=/data/tools/bowtie2-2.5.3-linux-x86_64:$PATH
export PATH=/data/tools/samtools-1.19:$PATH


for f in *_R1_001_val_1.fq
do
#   u=$(cut -d '_' -f 1 <<< $f)
  o=${f/'_R1_001_val_1.fq'/''}
  d="megahit_"$o
  bowtie2-build --threads 60 $d/final.contigs.fa $d/final.contigs
  bowtie2 --very-sensitive-local -p 60 -x $d/final.contigs -1 $f -2 ${f/'_R1_001_val_1.fq'/'_R2_001_val_2.fq'} | samtools view --threads 60 -Sb -F 4 | samtools sort --threads 60 > $d/final.contigs.bam
  samtools index $d/final.contigs.bam
done


export PATH=/data/tools/miniforge3/bin:$PATH

source activate SemiBin

r=/data/sn/vietnam/20240313/raw

cd $r
for f in megahit_*/final.contigs.fa
do
  d=$r/${f/'/final.contigs.fa'/''}
  cd $d
  SemiBin2 single_easy_bin -i final.contigs.fa -b final.contigs.bam -o SemiBin2
done

conda deactivate

cd $r
for f in megahit_*/final.contigs.fa
do
  d=$r/${f/'/final.contigs.fa'/''}
  cd $d
  docker run -u `id -u`:`id -g` \
   -w /home/data \
   -v $d:/home/data metabat \
   runMetaBat.sh -t 60 \
   /home/data/final.contigs.fa \
   /home/data/final.contigs.bam

  mv final.contigs.fa.metabat-* metabat
  for b in metabat/*.fa
  do
    mv $b ${b/'bin'/'metabat'}
  done
done


cd $r
for f in megahit_*/final.contigs.fa
do
  d=$r/${f/'/final.contigs.fa'/''}
  cd $d
  cut -f1,4 final.contigs.fa.depth.txt > final.contigs.abund
  mkdir maxbin2
  /data/sn/ONT/MaxBin-2.2.7/run_MaxBin.pl \
    -contig final.contigs.fa \
    -abund final.contigs.abund \
    -out maxbin2/maxbin
done

source activate MetaDecoder

cd $r
for f in megahit_*/final.contigs.fa
do
  d=$r/${f/'/final.contigs.fa'/''}
  cd $d
  samtools view -h -o final.contigs.sam final.contigs.bam
  mkdir metadecoder
  metadecoder coverage -s final.contigs.sam -o metadecoder/metadecoder.COVERAGE
  metadecoder seed --threads 60 -f final.contigs.fa -o metadecoder/metadecoder.SEED
  metadecoder cluster -f final.contigs.fa \
   -c metadecoder/metadecoder.COVERAGE \
   -s metadecoder/metadecoder.SEED \
   -o metadecoder/metadecoder
  rm final.contigs.sam
done

conda deactivate

# source activate concoct
#
# cd $r
# for f in megahit_*/final.contigs.fa
# do
#   d=$r/${f/'/final.contigs.fa'/''}
#   cd $d
#   mkdir concoct_output
#   mkdir concoct_output/fasta_bins
#   cut_up_fasta.py final.contigs.fa -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa
#   concoct_coverage_table.py contigs_10K.bed final.contigs.bam > coverage_table.tsv
#   concoct -t 60 --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b concoct_output
#   merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv
#   extract_fasta_bins.py final.contigs.fa concoct_output/clustering_merged.csv \
#  --output_path concoct_output/fasta_bins
# done
#
# conda deactivate
# OpenBLAS Warning : Detect OpenMP Loop and this application may hang. Please rebuild the library with USE_OPENMP=1 option.


td=/data/tools/MetaBinner

source activate metabinner
export PATH=/data/tools/MetaBinner/scripts:$PATH
td=/data/tools/MetaBinner

cd $r
for f in megahit_*/final.contigs.fa
do
  d=$r/${f/'/final.contigs.fa'/''}
  cd $d
  cat final.contigs.fa.depth.txt | cut -f -1,4- > coverage_profile.tsv
  cat final.contigs.fa.depth.txt | awk '{if ($2>1000) print $0 }' | cut -f -1,4- > coverage_profile_f1k.tsv
  Filter_tooshort.py final.contigs.fa 1000
  gen_kmer.py final.contigs_1000.fa 1000 4
  run_metabinner.sh -a $d/final.contigs_1000.fa \
    -o $d/metabinner_output \
    -d $d/coverage_profile_f1k.tsv \
    -k $d/final.contigs_1000_kmer_4_f1000.csv \
    -p $td -t 60
done

conda deactivate

source activate das

cd $r
for f in megahit_*/final.contigs.fa
do
  d=$r/${f/'/final.contigs.fa'/''}
  cd $d
  gunzip SemiBin2/output_bins/*.gz
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./SemiBin2/output_bins -e fa > bins_SemiBin2.tsv
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./metabat -e fa > bins_metabat.tsv
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./maxbin2 -e fasta > bins_maxbin2.tsv
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./metadecoder -e fasta > bins_metadecoder.tsv
  perl -pe "s/\t/\tmetabinner./g;" metabinner_output/metabinner_res/metabinner_result.tsv > bins_metabinner.tsv

  DAS_Tool \
    -i bins_SemiBin2.tsv,bins_metabat.tsv,bins_maxbin2.tsv,bins_metadecoder.tsv,bins_metabinner.tsv \
    -l SemiBin2,metabat,maxbin2,metadecoder,metabinner \
    -c final.contigs.fa \
    -o das_res/run1 \
    --write_bins --write_bin_evals --threads 60
done

conda deactivate

ls megahit_FR*/das_res/run1_DASTool_bins/

cp megahit_FR14_S88_L001/das_res/run1_DASTool_bins/metabinner.1.fa bins/FR14_metabinner.1.fa
cp megahit_FR14_S88_L001/das_res/run1_DASTool_bins/metabinner.2.fa bins/FR14_metabinner.2.fa
cp megahit_FR5_S79_L001/das_res/run1_DASTool_bins/maxbin.002_sub.fa bins/FR05_maxbin.002_sub.fa
cp megahit_FR5_S79_L001/das_res/run1_DASTool_bins/metabinner.1.fa bins/FR05_maxbin.002_sub.fa
cp megahit_FR9_S83_L001/das_res/run1_DASTool_bins/metabinner.2.fa bins/FR09_metabinner.2.fa
cp megahit_FR9_S83_L001/das_res/run1_DASTool_bins/metadecoder.1.fa bins/FR09_metadecoder.1.fa

source activate checkm2

export CHECKM2DB=/data/dbs/CheckM2_database/uniref100.KO.1.dmnd

cd $r
checkm2 predict --threads 60 \
  --input bins \
  --output-directory bins_checkm2 -x .fa

conda deactivate

cd $r

source activate gtdbtk
# conda env config vars set GTDBTK_DATA_PATH="/data/dbs/gtdbtk_db/release214";

gtdbtk identify --genome_dir bins/ \
  --out_dir bins/identify --extension fa --cpus 60

gtdbtk align --identify_dir bins/identify \
  --out_dir bins/align --cpus 60

gtdbtk classify --genome_dir bins/ \
  --align_dir bins/align --out_dir bins/classify \
  --mash_db bins/mashdb -x fa --cpus 60

conda deactivate


export PGAP_INPUT_DIR=/data/sn/pgap
# cd $PGAP_INPUT_DIR
# ./pgap.py --update

../pgap.py -v --cpus 36 -r --taxcheck-only -o FR05_maxbin.002_sub_check -g FR05_maxbin.002_sub.fa -s 'Serratia nematodiphila'
../pgap.py -v --cpus 36 -r --taxcheck-only -o FR09_metabinner.2_check -g FR09_metabinner.2.fa -s 'Stenotrophomonas sepilia'
../pgap.py -v --cpus 36 -r --taxcheck-only -o FR09_metadecoder.1_check -g FR09_metadecoder.1.fa -s 'Chryseobacterium cucumeris'
../pgap.py -v --cpus 36 -r --taxcheck-only -o FR14_metabinner.1_check -g FR14_metabinner.1.fa -s 'Aeromonas dhakensis'
../pgap.py -v --cpus 36 -r --taxcheck-only -o FR14_metabinner.2_check -g FR14_metabinner.2.fa -s 'Spiroplasma turonicum'

mkdir contigs


for f in *_R1_001_val_1.fq
do
  u=$(cut -d '_' -f 1 <<< $f)
  o=${f/'_R1_001_val_1.fq'/''}
  d="megahit_"$o
  cp $d/final.contigs.fa 'contigs/'$u'_final.contigs.fa'
done


export PATH=/store/sn/tools/ncbi-blast-2.14.1+/bin:$PATH

for f in *.fa
do
  blastn -num_threads 50 -query $f -db nt -outfmt "6 qseqid staxids sscinames stitle sseqid pident qcovs length mismatch gapopen qstart qend sstart send evalue bitscore" > ${f/'.fa'/'.tsv'}
done



