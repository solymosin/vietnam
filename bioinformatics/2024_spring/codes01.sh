nextcloudcmd /data/sn/viet_seq https://91.83.105.2:8080

--user solymosi --password fu?;#9VsY4F<mWj3>G.7/M

cd /data/sn/viet_seq/20230925/SolymosiN_kullancsMG

mkdir raw
mv */*.gz raw

export PATH=/data/tools/TrimGalore-0.6.7:$PATH
export PATH=/data/tools/FastQC:$PATH

for f in *.gz
do
  fastqc -o qc -t 10 $f
done


cat 32-NAGY-M_S101_L001_R1_001.fastq.gz 32-NAGY-M_S101_L002_R1_001.fastq.gz > 32-NAGY-M_1.fq.gz
cat 32-NAGY-M_S101_L001_R2_001.fastq.gz 32-NAGY-M_S101_L002_R2_001.fastq.gz > 32-NAGY-M_2.fq.gz

cat 33-NAGY-M_S102_L001_R1_001.fastq.gz 33-NAGY-M_S102_L002_R1_001.fastq.gz > 33-NAGY-M_1.fq.gz
cat 33-NAGY-M_S102_L001_R2_001.fastq.gz 33-NAGY-M_S102_L002_R2_001.fastq.gz > 33-NAGY-M_2.fq.gz

cat 34-KICSI-M_S103_L001_R1_001.fastq.gz 34-KICSI-M_S103_L002_R1_001.fastq.gz > 34-KICSI-M_1.fq.gz
cat 34-KICSI-M_S103_L001_R2_001.fastq.gz 34-KICSI-M_S103_L002_R2_001.fastq.gz > 34-KICSI-M_2.fq.gz

cat 35-NAGY-M_S104_L001_R1_001.fastq.gz 35-NAGY-M_S104_L002_R1_001.fastq.gz > 35-NAGY-M_1.fq.gz
cat 35-NAGY-M_S104_L001_R2_001.fastq.gz 35-NAGY-M_S104_L002_R2_001.fastq.gz > 35-NAGY-M_2.fq.gz

cat 37-NAGY-M_S105_L001_R1_001.fastq.gz 37-NAGY-M_S105_L002_R1_001.fastq.gz > 37-NAGY-M_1.fq.gz
cat 37-NAGY-M_S105_L001_R2_001.fastq.gz 37-NAGY-M_S105_L002_R2_001.fastq.gz > 37-NAGY-M_2.fq.gz

cat 38-NAGY-M_S106_L001_R1_001.fastq.gz 38-NAGY-M_S106_L002_R1_001.fastq.gz > 38-NAGY-M_1.fq.gz
cat 38-NAGY-M_S106_L001_R2_001.fastq.gz 38-NAGY-M_S106_L002_R2_001.fastq.gz > 38-NAGY-M_2.fq.gz

cat 39-NAGY-M_S107_L001_R1_001.fastq.gz 39-NAGY-M_S107_L002_R1_001.fastq.gz > 39-NAGY-M_1.fq.gz
cat 39-NAGY-M_S107_L001_R2_001.fastq.gz 39-NAGY-M_S107_L002_R2_001.fastq.gz > 39-NAGY-M_2.fq.gz

cat 40-NAGY-M_S108_L001_R1_001.fastq.gz 40-NAGY-M_S108_L002_R1_001.fastq.gz > 40-NAGY-M_1.fq.gz
cat 40-NAGY-M_S108_L001_R2_001.fastq.gz 40-NAGY-M_S108_L002_R2_001.fastq.gz > 40-NAGY-M_2.fq.gz

cat 41-KICSI-M_S110_L001_R1_001.fastq.gz 41-KICSI-M_S110_L002_R1_001.fastq.gz > 41-KICSI-M_1.fq.gz
cat 41-KICSI-M_S110_L001_R2_001.fastq.gz 41-KICSI-M_S110_L002_R2_001.fastq.gz > 41-KICSI-M_2.fq.gz

cat 41-NAGY-M_S109_L001_R1_001.fastq.gz 41-NAGY-M_S109_L002_R1_001.fastq.gz > 41-NAGY-M_1.fq.gz
cat 41-NAGY-M_S109_L001_R2_001.fastq.gz 41-NAGY-M_S109_L002_R2_001.fastq.gz > 41-NAGY-M_2.fq.gz

cat 42-NAGY-M_S111_L001_R1_001.fastq.gz 42-NAGY-M_S111_L002_R1_001.fastq.gz > 42-NAGY-M_1.fq.gz
cat 42-NAGY-M_S111_L001_R2_001.fastq.gz 42-NAGY-M_S111_L002_R2_001.fastq.gz > 42-NAGY-M_2.fq.gz

cat 43-NAGY-M_S112_L001_R1_001.fastq.gz 43-NAGY-M_S112_L002_R1_001.fastq.gz > 43-NAGY-M_1.fq.gz
cat 43-NAGY-M_S112_L001_R2_001.fastq.gz 43-NAGY-M_S112_L002_R2_001.fastq.gz > 43-NAGY-M_2.fq.gz

cat 45-NAGY-M_S113_L001_R1_001.fastq.gz 45-NAGY-M_S113_L002_R1_001.fastq.gz > 45-NAGY-M_1.fq.gz
cat 45-NAGY-M_S113_L001_R2_001.fastq.gz 45-NAGY-M_S113_L002_R2_001.fastq.gz > 45-NAGY-M_2.fq.gz

cat 59-NAGY-M_S114_L001_R1_001.fastq.gz 59-NAGY-M_S114_L002_R1_001.fastq.gz > 59-NAGY-M_1.fq.gz
cat 59-NAGY-M_S114_L001_R2_001.fastq.gz 59-NAGY-M_S114_L002_R2_001.fastq.gz > 59-NAGY-M_2.fq.gz

cat HNV_07_S2022_NAGY_M.gz HNV_07_S2022_NAGY-M_S100_L002_R1_001.fastq.gz > HNV_07_S2022_NAGY_M_1.fq.gz
cat HNV_07_S2022_NAGY_M_S100_L001_R2_001.fastq.gz HNV_07_S2022_NAGY-M_S100_L002_R2_001.fastq.gz > HNV_07_S2022_NAGY_M_2.fq.gz

cat TBV_22_S2022_KICSI-M_S96_L001_R1_001.fastq.gz TBV_22_S2022_KICSI-M_S96_L002_R1_001.fastq.gz > TBV_22_S2022_KICSI-M_1.fq.gz
cat TBV_22_S2022_KICSI-M_S96_L001_R2_001.fastq.gz TBV_22_S2022_KICSI-M_S96_L002_R2_001.fastq.gz > TBV_22_S2022_KICSI-M_2.fq.gz

cat TNV_05_S2022_NAGY-M_S97_L001_R1_001.fastq.gz TNV_05_S2022_NAGY-M_S97_L002_R1_001.fastq.gz > TNV_05_S2022_NAGY-M_1.fq.gz
cat TNV_05_S2022_NAGY-M_S97_L001_R2_001.fastq.gz TNV_05_S2022_NAGY-M_S97_L002_R2_001.fastq.gz > TNV_05_S2022_NAGY-M_2.fq.gz

cat TNV_06_S2022NAGY-M_S98_L001_R1_001.fastq.gz TNV_06_S2022NAGY-M_S98_L002_R1_001.fastq.gz > TNV_06_S2022NAGY-M_1.fq.gz
cat TNV_06_S2022NAGY-M_S98_L001_R2_001.fastq.gz TNV_06_S2022NAGY-M_S98_L002_R2_001.fastq.gz > TNV_06_S2022NAGY-M_2.fq.gz

cat TNV_09_S2022_NAGY-M_S99_L001_R1_001.fastq.gz TNV_09_S2022_NAGY-M_S99_L002_R1_001.fastq.gz > TNV_09_S2022_NAGY-M_1.fq.gz
cat TNV_09_S2022_NAGY-M_S99_L001_R2_001.fastq.gz TNV_09_S2022_NAGY-M_S99_L002_R2_001.fastq.gz > TNV_09_S2022_NAGY-M_2.fq.gz

for f in *_1.fq.gz
do
  trim_galore --cores 8 \
    --dont_gzip \
    --quality 20 \
    --length 50 \
    --paired $f ${f/'_1.fq.gz'/'_2.fq.gz'}
done

export PATH=/data/tools/kraken2-2.1.2:$PATH

db='/data/tools/kraken2-2.1.2/nt'

for f in *_1_val_1.fq
do
  rpt=${f/'_1_val_1.fq'/'.rpt'}
  out=${f/'_1_val_1.fq'/'.kraken'}
  kraken2 --threads 38 --db $db --report $rpt --output $out --paired $f ${f/'_1_val_1.fq'/'_2_val_2.fq'}
done



export PATH=/data/tools/kraken2-2.1.2:$PATH

db='/data/tools/kraken2-2.1.2/nt'

for f in *_1_val_1.fq
do
  rpt=${f/'_1_val_1.fq'/'.rpt'}
  out=${f/'_1_val_1.fq'/'.kraken'}
  kraken2 --threads 50 --db $db --report $rpt --output $out --paired $f ${f/'_1_val_1.fq'/'_2_val_2.fq'}
done

kraken-biom *.rpt --fmt json -o vietnam01_nt.biom

library(phyloseq)
library(microbiome)
library(tidyverse)
library(psadd)

dat = import_biom('vietnam01_nt.biom', parseFunction=parse_taxonomy_greengenes)

sd = data.frame(SampleID=colnames(otu_table(dat)))
rownames(sd) = sd$SampleID
sample_data(dat) = sd
plot_krona(dat, 'vietnam01_nt', 'SampleID', trim=T)

python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k HNV_07_S2022_NAGY_M.kraken \
  -s HNV_07_S2022_NAGY_M_1_val_1.fq \
  -s2 HNV_07_S2022_NAGY_M_2_val_2.fq \
  -r HNV_07_S2022_NAGY_M.rpt \
  -t 2747498 --include-children \
  --fastq-output -o HNV_07_S2022_NAGY_M_Musca_hytrosavirus_1.fq -o2 HNV_07_S2022_NAGY_M_Musca_hytrosavirus_2.fq


python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k 45-NAGY-M.kraken \
  -s 45-NAGY-M_1_val_1.fq \
  -s2 45-NAGY-M_2_val_2.fq \
  -r 45-NAGY-M.rpt \
  -t 2842886 --include-children \
  --fastq-output -o 45-NAGY-M_Muscodensovirus_1.fq -o2 45-NAGY-M_Muscodensovirus_2.fq


export PATH=/data/tools/megahit/build:$PATH

megahit -t 50 -1 HNV_07_S2022_NAGY_M_Musca_hytrosavirus_1.fq -2 HNV_07_S2022_NAGY_M_Musca_hytrosavirus_2.fq -o HNV_07_S2022_NAGY_M_Musca_hytrosavirus

megahit -t 50 -1 45-NAGY-M_Muscodensovirus_1.fq -2 45-NAGY-M_Muscodensovirus_2.fq -o 45-NAGY-M_Muscodensovirus

for f in *_1_val_1.fq
do
  r=${f/'_1_val_1.fq'/'_2_val_2.fq'}
  o=${f/'_1_val_1.fq'/''}
  d="megahit_"$o
  if [ ! -d $d ]
  then
    megahit -t 50 -1 $f -2 $r -o $d
  fi
done

mkdir contigs
for f in megahit_*/final.contigs.fa
do
  a=${f/'megahit_'/''}
  b=${a/'/'/'_'}
  cp $f 'contigs/'$b
done

db='/data/tools/kraken2-2.1.2/nt'

for f in *.fa
do
  rpt=${f/'.fa'/'.rpt'}
  out=${f/'.fa'/'.kraken'}
  kraken2 --confidence 0.5 --threads 50 --db $db --report $rpt --output $out $f
done

kraken-biom *.rpt --fmt json -o vietnam01_contigs_nt50.biom

for f in *.fa
do
  rpt=${f/'.fa'/'_c00.rpt'}
  out=${f/'.fa'/'_c00.kraken'}
  kraken2 --threads 50 --db $db --report $rpt --output $out $f
done

kraken-biom *_c00.rpt --fmt json -o vietnam01_contigs_nt00.biom




library(phyloseq)
library(microbiome)
library(tidyverse)
library(psadd)

dat = import_biom('vietnam01_contigs_nt50.biom', parseFunction=parse_taxonomy_greengenes)
colnames(otu_table(dat)) = gsub('_final.contigs', '', colnames(otu_table(dat)))
sd = data.frame(SampleID=colnames(otu_table(dat)))
rownames(sd) = sd$SampleID
sample_data(dat) = sd
plot_krona(dat, 'vietnam01_contigs_nt50', 'SampleID', trim=T)

dat = import_biom('vietnam01_contigs_nt00.biom', parseFunction=parse_taxonomy_greengenes)
colnames(otu_table(dat)) = gsub('_final.contigs_c00', '', colnames(otu_table(dat)))
sd = data.frame(SampleID=colnames(otu_table(dat)))
rownames(sd) = sd$SampleID
sample_data(dat) = sd
plot_krona(dat, 'vietnam01_contigs_nt00', 'SampleID', trim=T)


python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k HNV_07_S2022_NAGY_M_final.contigs_c00.kraken \
  -r HNV_07_S2022_NAGY_M_final.contigs_c00.rpt \
  -s HNV_07_S2022_NAGY_M_final.contigs.fa \
  -t 523909 \
  -o HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus.fa



export PATH=/data/tools/prokka/bin:$PATH
export PATH=/data/tools/prokka/binaries/linux:$PATH

cd /data/sn/viet_seq/20230925/SolymosiN_kullancsMG/contigs

prokka --compliant --locustag 'MdSGHV' --cpus 50 --kingdom Virus --proteins ncbi_dataset/data/GCF_000879935.1/protein.faa --outdir HNV_07_S2022_NAGY_M HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final.fa

export PATH=/data/tools/bowtie2-2.4.5-linux-x86_64:$PATH
export PATH=/data/tools/samtools-1.14:$PATH

bowtie2-build HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final.fa HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final

bowtie2 --very-sensitive-local -p 50 -x HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final \
-1 ../HNV_07_S2022_NAGY_M_1_val_1.fq \
-2 ../HNV_07_S2022_NAGY_M_2_val_2.fq | \
samtools view -Sb -F 4 | \
samtools sort > HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final.bam
samtools index HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final.bam

samtools mpileup -a HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final.bam > HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final.pileup

library(tidyverse)

tab = read_tsv('HNV_07_S2022_NAGY_M_final.contigs_c00_Musca_hytrosavirus_final.pileup', col_names=F)
mean(tab$X4)
median(tab$X4)
12

mafft --auto all_dnapoly.fa > all_dnapoly.aln


################################################################################x
# R

# https://cran.r-project.org/web/packages/phangorn/vignettes/Trees.html

library(Biostrings)
library(tidyverse)
library(phangorn)
library(RColorBrewer)
library(ggtree)
library(ape)
library(tidytree)
library(ggbreak)

setwd('/home/sn/dev/aote/Para/Vietnam/Viet_seq')

aln_all = readAAStringSet('all_dnapoly.aln')
aln_all = subseq(aln_all, 598,781)

msa = as.AAbin(aln_all)
msa.dat = phyDat(msa, type = "AA", levels = NULL)
set.seed(2022)

aa_models = c('WAG', 'JTT', 'LG', 'Dayhoff', 'cpREV', 'mtmam', 'mtArt', 'MtZoa', 'mtREV24', 'VT', 'RtREV', 'HIVw', 'HIVb', 'FLU', 'Blosum62', 'Dayhoff_DCMut', 'JTT_DCMut')

mt = modelTest(msa.dat, model=aa_models[-6], multicore=F)
mt$Model[mt$BIC==min(mt$BIC)]

dm = dist.ml(msa, model='LG')
msa_nj = NJ(dm)
msa.pml = pml(msa_nj, msa.dat, model='LG')
msa.pml = optim.pml(msa.pml, optNNi=T, model='LG', optBf=T, optQ=T, optInv=T, optGamma=T, optEdge=T) #optInv

# save.image(file='phylo.RData')
load('phylo.RData')

set.seed(2023)
# bs = bootstrap.pml(msa.pml, bs=100)
# bs = bootstrap.pml(msa.pml, bs=100, model='LG', optNni=T, optInv=T, control=pml.control(trace=0))
# ooted / unrooted tree needs at least 2 / 3 tips
bs = bootstrap.pml(msa.pml, bs=100, model='LG', optNni=F, optInv=T, control=pml.control(trace=0))

bs_tree = plotBS(msa.pml$tree, bs)

getPalette = colorRampPalette(brewer.pal(9, 'Paired'))

td = as.tibble(matrix(c(
'ACY25172.1', 'Musca domestica', 'Virgin Islands: ?',
'ACY25171.1', 'Musca domestica', 'Denmark: Morum, North Jutland',
'ACY25170.1', 'Musca domestica', 'Denmark: Tonder, South Jutland',
'ACY25169.1', 'Musca domestica', 'Denmark: Havbro, North Jutland',
'ACY25168.1', 'Musca domestica', 'Denmark: Slangerup',
'ACY25167.1', 'Musca domestica', 'Thailand: Samut Sakorn',
'ACY25166.1', 'Musca domestica', 'Thailand: Prajinburi',
'ACY25165.1', 'Musca domestica', 'Thailand: Samut Sakorn',
'ACY25164.1', 'Musca domestica', 'New Zealand: Lincoln',
'ACY25163.1', 'Musca domestica', 'New Zealand: Green Park',
'ACY25162.1', 'Musca domestica', 'USA: California',
'ACY25161.1', 'Musca domestica', 'USA: Kansas',
'ACY25160.1', 'Musca domestica', 'USA: Alachua, Florida',
'ACY25159.1', 'Musca domestica', 'USA: Alachua, Florida',
'ACY25158.1', 'Musca domestica', 'USA: Okeechobee, Florida',
'ACY25157.1', 'Musca domestica', 'USA: Alachua, Florida',
'HNV', 'Musca domestica', 'Vietnam: ?',
'ACD03460.1', 'Musca domestica', 'USA: ?'), nc=3, byrow=T))
colnames(td) = c('pid', 'species', 'Country')
td = td |> separate(Country, 'Country', ':')

bs_tree |> ggtree(branch.length='none', layout="circular")  + geom_tiplab(aes(angle=angle), hjust = -.1, color='black') + geom_nodelab(geom='label') +
geom_treescale(linesize=0, fontsize=0, width=5) + scale_color_manual(values= getPalette(12))

bs_tree |> ggtree(layout="circular")  + geom_tiplab(aes(angle=angle), hjust = -.1, color='black') + geom_nodelab(geom='label') +
geom_treescale(linesize=0, fontsize=0, width=5) + scale_color_manual(values= getPalette(12))

# bs_treev2 = root(bs_tree, outgroup=c('MH243373.1'), resolve.root = TRUE)
# bs_treev2 = root(bs_tree, resolve.root=F)


# bs_tree %>%
# as.treedata %>%
# as_tibble %>%
# mutate(branch.length=sqrt(branch.length)) %>%
# as.phylo |>
# ggtree() +
# ggtree() %<+% td +
# geom_tiplab(geom='label', aes(fill=Country), nudge_x=0.005) +
# geom_tree(aes(color=Country), size=1) +
# geom_nodelab(geom='label', fill='white') +
# geom_treescale(linesize=0.1, fontsize=0, width=1) +
# scale_fill_manual(values= getPalette(12)) +
# coord_cartesian(clip = 'off') +
# theme_tree2(plot.margin=margin(6, 70, 6, 6)) +
# theme(legend.position=c(0.9,0.3)) +
# guides(fill = guide_legend(override.aes=aes(label='')))
# ggsave(filename='../../ms/fig_phylo.pdf', width=9, height=7)

bs_tree |> ggtree(branch.length='none', layout="circular")  %<+% td +
# geom_tiplab(aes(angle=angle), hjust = -.1, color='black') +
geom_tiplab(geom='label', aes(fill=Country)) +
geom_nodelab(geom='label') +
# geom_tree(aes(color=Country), size=1) +
geom_nodelab(geom='label', fill='white')
ggsave(filename='fig_phylo.pdf', width=11, height=11)

bs_tree %>%
as.treedata %>%
as_tibble %>%
mutate(branch.length=sqrt(branch.length)) %>%
as.phylo |> ggtree(branch.length='none')  %<+% td +
# geom_tiplab(aes(angle=angle), hjust = -.1, color='black') +
geom_tiplab(geom='label', aes(fill=Country)) +
geom_nodelab(geom='label') +
# geom_tree(aes(color=Country), size=1) +
geom_nodelab(geom='label', fill='white') +
geom_treescale(linesize=0.1, fontsize=0, width=1) +
scale_fill_manual(values= getPalette(12)) +
coord_cartesian(clip = 'off') +
theme_tree2(plot.margin=margin(6, 70, 6, 6)) +
theme(legend.position=c(0.1,0.8)) +
guides(fill = guide_legend(override.aes=aes(label='')))
ggsave(filename='fig_phylo.pdf', width=9, height=6)


bs_tree %>%
as.treedata %>%
as_tibble %>%
mutate(branch.length=sqrt(branch.length)) %>%
as.phylo |> ggtree(branch.length='none', layout="circular")  %<+% td +
# geom_tiplab(aes(angle=angle), hjust = -.1, color='black') +
geom_tiplab(geom='label', aes(fill=Country)) +
# geom_nodelab(geom='label') +
# geom_tree(aes(color=Country), size=1) +
# geom_nodelab(geom='label', fill='white') +
# geom_treescale(linesize=0.1, fontsize=0, width=1) +
scale_fill_manual(values= getPalette(12)) +
# coord_cartesian(clip = 'off') +
# theme_tree2(plot.margin=margin(6, 70, 6, 6)) +
theme(legend.position=c(0.63,0.41), legend.background = element_rect(fill='transparent')) +
guides(fill = guide_legend(override.aes=aes(label='')))+
ggsave(filename='fig_phylob.pdf', width=8, height=7.8)



babesia
anaplasma
trypanosoma

for r in *.rpt
do
 f=${r/'.rpt'/''}
 python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k $f'.kraken' \
  -r $r \
  -s $f'_1_val_1.fq' -s2 $f'_2_val_2.fq' \
  -t 766 --include-children \
  -o $f'_anaplasma_1.fq' -o2 $f'_anaplasma_2.fq'

 python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k $f'.kraken' \
  -r $r \
  -s $f'_1_val_1.fq' -s2 $f'_2_val_2.fq' \
  -t 32594 --include-children \
  -o $f'_babesia_1.fq' -o2 $f'_babesia_2.fq'

 python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k $f'.kraken' \
  -r $r \
  -s $f'_1_val_1.fq' -s2 $f'_2_val_2.fq' \
  -t 2704949 --include-children \
  -o $f'_trypanosoma_1.fq' -o2 $f'_trypanosoma_2.fq'

 python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k $f'.kraken' \
  -r $r \
  -s $f'_1_val_1.fq' -s2 $f'_2_val_2.fq' \
  -t 5794 --include-children \
  -o $f'_apicomplexa_1.fq' -o2 $f'_apicomplexa_2.fq'

done



r=TBV_22_S2022_KICSI-M.rpt
f=${r/'.rpt'/''}
python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k $f'.kraken' \
  -r $r \
  -s $f'_1_val_1.fq' -s2 $f'_2_val_2.fq' \
  -t 586 --include-children \
  -o $f'_providencia_1.fq' -o2 $f'_providencia_2.fq'

export PATH=/data/tools/megahit/build:$PATH

megahit -t 50 -1 TBV_22_S2022_KICSI-M_providencia_1.fq -2 TBV_22_S2022_KICSI-M_providencia_2.fq -o TBV_22_S2022_KICSI-M_providencia

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/204/135/GCF_003204135.1_ASM320413v1/GCF_003204135.1_ASM320413v1_genomic.fna.gz
bowtie2-build GCF_003204135.1_ASM320413v1_genomic.fna.gz Prettgeri

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/393/505/GCF_002393505.1_ASM239350v1/GCF_002393505.1_ASM239350v1_genomic.fna.gz
bowtie2-build GCF_002393505.1_ASM239350v1_genomic.fna.gz Palcalifaciens


bowtie2 --very-sensitive-local -p 50 -x Prettgeri \
-1 TBV_22_S2022_KICSI-M_1_val_1.fq \
-2 TBV_22_S2022_KICSI-M_2_val_2.fq | \
samtools view -Sb -F 4 | \
samtools sort > TBV_22_S2022_KICSI-M_Prettgeri.bam
samtools index TBV_22_S2022_KICSI-M_Prettgeri.bam

7201003 reads; of these:
  7201003 (100.00%) were paired; of these:
    7173564 (99.62%) aligned concordantly 0 times
    26686 (0.37%) aligned concordantly exactly 1 time
    753 (0.01%) aligned concordantly >1 times
    ----
    7173564 pairs aligned concordantly 0 times; of these:
      446 (0.01%) aligned discordantly 1 time
    ----
    7173118 pairs aligned 0 times concordantly or discordantly; of these:
      14346236 mates make up the pairs; of these:
        14345348 (99.99%) aligned 0 times
        797 (0.01%) aligned exactly 1 time
        91 (0.00%) aligned >1 times
0.39% overall alignment rate

bowtie2 --very-sensitive-local -p 50 -x Palcalifaciens \
-1 TBV_22_S2022_KICSI-M_1_val_1.fq \
-2 TBV_22_S2022_KICSI-M_2_val_2.fq | \
samtools view -Sb -F 4 | \
samtools sort > TBV_22_S2022_KICSI-M_Palcalifaciens.bam
samtools index TBV_22_S2022_KICSI-M_Palcalifaciens.bam

7201003 reads; of these:
  7201003 (100.00%) were paired; of these:
    7189913 (99.85%) aligned concordantly 0 times
    9958 (0.14%) aligned concordantly exactly 1 time
    1132 (0.02%) aligned concordantly >1 times
    ----
    7189913 pairs aligned concordantly 0 times; of these:
      133 (0.00%) aligned discordantly 1 time
    ----
    7189780 pairs aligned 0 times concordantly or discordantly; of these:
      14379560 mates make up the pairs; of these:
        14377491 (99.99%) aligned 0 times
        1415 (0.01%) aligned exactly 1 time
        654 (0.00%) aligned >1 times
0.17% overall alignment rate

samtools mpileup -a TBV_22_S2022_KICSI-M_Prettgeri.bam > TBV_22_S2022_KICSI-M_Prettgeri.pileup
samtools mpileup -a TBV_22_S2022_KICSI-M_Palcalifaciens.bam > TBV_22_S2022_KICSI-M_Palcalifaciens.pileup

library(tidyverse)

tab = read_tsv('TBV_22_S2022_KICSI-M_Prettgeri.pileup', col_names=F)
mean(tab$X4)
median(tab$X4)
sum(tab$X4==0)/length(tab$X4)

tab = read_tsv('TBV_22_S2022_KICSI-M_Palcalifaciens.pileup', col_names=F)
mean(tab$X4)
median(tab$X4)
sum(tab$X4==0)/length(tab$X4)

/data/sn/viet_seq/20230925/SolymosiN_kullancsMG/megahit_TBV_22_S2022_KICSI-M

export PATH=/data/tools/MaSuRCA-4.1.0/bin:$PATH
export PATH=/data/tools/bwa:$PATH

polca.sh -a final.contigs.fa -r '../GCF_003204135.1_ASM320413v1_genomic.fna.gz ../TBV_22_S2022_KICSI-M_1_val_1.fq ../TBV_22_S2022_KICSI-M_2_val_2.fq' -t 50 -m 10G

export PATH=/data/tools/mambaforge/bin:$PATH
source activate ragtag

ragtag.py correct ../GCF_003204135.1_ASM320413v1_genomic.fna.gz final.contigs.fa
# ragtag.py scaffold ../GCF_003204135.1_ASM320413v1_genomic.fna.gz ragtag_output/ragtag.correct.fasta




r=45-NAGY-M.rpt
# Haematobia irritans densovirus
f=${r/'.rpt'/''}
python /data/tools/KrakenTools/extract_kraken_reads.py \
  -k $f'.kraken' \
  -r $r \
  -s $f'_1_val_1.fq' -s2 $f'_2_val_2.fq' \
  -t 2575447 \
  -o $f'_HI_densovirus_1.fq' -o2 $f'_HI_densovirus_2.fq'

megahit -t 50 -1 45-NAGY-M_HI_densovirus_1.fq -2 45-NAGY-M_HI_densovirus_2.fq -o 45-NAGY-M_HI_densovirus


for f in *_anaplasma_1.fq
do
  megahit -t 50 -1 $f -2 ${f/'_1.fq'/'_2.fq'} -o 'megahit_'${f/'_1.fq'/''}
done

for f in *_babesia_1.fq
do
  megahit -t 50 -1 $f -2 ${f/'_1.fq'/'_2.fq'} -o 'megahit_'${f/'_1.fq'/''}
done

for f in *_trypanosoma_1.fq
do
  megahit -t 50 -1 $f -2 ${f/'_1.fq'/'_2.fq'} -o 'megahit_'${f/'_1.fq'/''}
done

for f in *_apicomplexa_1.fq
do
  megahit -t 50 -1 $f -2 ${f/'_1.fq'/'_2.fq'} -o 'megahit_'${f/'_1.fq'/''}
done

mkdir assemblies
for f in megahit_*_anaplasma/final.contigs.fa
do
  a=${f/'megahit_'/''}
  b=${a/'/'/'_'}
  cp $f 'assemblies/'$b
done

for f in megahit_*_babesia/final.contigs.fa
do
  a=${f/'megahit_'/''}
  b=${a/'/'/'_'}
  cp $f 'assemblies/'$b
done

for f in megahit_*_trypanosoma/final.contigs.fa
do
  a=${f/'megahit_'/''}
  b=${a/'/'/'_'}
  cp $f 'assemblies/'$b
done

for f in megahit_*_apicomplexa/final.contigs.fa
do
  a=${f/'megahit_'/''}
  b=${a/'/'/'_'}
  cp $f 'assemblies/'$b
done

cd /data/sn/viet_seq/20230925/SolymosiN_kullancsMG/assemblies

db='/data/tools/kraken2-2.1.2/nt'

for f in *.fa
do
  rpt=${f/'.fa'/'_05.rpt'}
  out=${f/'.fa'/'_05.kraken'}
  kraken2 --confidence 0.5 --threads 50 --db $db --report $rpt --output $out $f
done

###################################### binning
export PATH=/data/tools/bowtie2-2.4.5-linux-x86_64:$PATH
export PATH=/data/tools/samtools-1.14:$PATH

r=/data/sn/viet_seq/20230925/SolymosiN_kullancsMG
cd $r

for f in *_1_val_1.fq
do
  d=megahit_${f/'_1_val_1.fq'/''}
  bowtie2-build --threads 60 $d/final.contigs.fa $d/final.contigs
  bowtie2 --very-sensitive-local -p 60 -x $d/final.contigs -1 $f -2 ${f/'_1_val_1.fq'/'_2_val_2.fq'} > $d/final.contigs.sam
  samtools view --threads 60 -Sb $d/final.contigs.sam | samtools sort --threads 60 > $d/final.contigs.bam
  samtools index $d/final.contigs.bam
done

export PATH=/data/tools/miniforge3/bin:$PATH

source activate SemiBin

for f in *_1_val_1.fq
do
  d=megahit_${f/'_1_val_1.fq'/''}
  cd $d
  SemiBin2 single_easy_bin -i final.contigs.fa -b final.contigs.bam -o semibin
  cd ../
done

conda deactivate


for f in *_1_val_1.fq
do
  d=$r'/megahit_'${f/'_1_val_1.fq'/''}
  cd $d
  docker run -u `id -u`:`id -g` \
   -w /home/data \
   -v $d:/home/data metabat \
   runMetaBat.sh -t 50 \
   /home/data/final.contigs.fa \
   /home/data/final.contigs.bam

  mv final.contigs.fa.metabat-* metabat
  for b in metabat/*.fa
  do
    mv $b ${b/'bin'/'metabat'}
  done

done

for f in *_1_val_1.fq
do
  d=$r'/megahit_'${f/'_1_val_1.fq'/''}
  cd $d
  cut -f1,3 final.contigs.fa.depth.txt > final.contigs.abund
  mkdir maxbin2
  /data/sn/ONT/MaxBin-2.2.7/run_MaxBin.pl -contig final.contigs.fa -abund final.contigs.abund -out maxbin2/maxbin

done

cd $r

source activate MetaDecoder

for f in *_1_val_1.fq
do
  d=$r'/megahit_'${f/'_1_val_1.fq'/''}
  cd $d
  mkdir metadecoder
  metadecoder coverage -s final.contigs.sam -o metadecoder/metadecoder.COVERAGE
  metadecoder seed --threads 50 -f final.contigs.fa -o metadecoder/metadecoder.SEED
  metadecoder cluster -f final.contigs.fa -c metadecoder/metadecoder.COVERAGE -s metadecoder/metadecoder.SEED -o metadecoder/metadecoder

done

conda deactivate

cd $r

source activate concoct

for f in *_1_val_1.fq
do
  d=$r'/megahit_'${f/'_1_val_1.fq'/''}
  cd $d
  cut_up_fasta.py final.contigs.fa -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa
  concoct_coverage_table.py contigs_10K.bed final.contigs.bam > coverage_table.tsv
  mkdir concoct_output
  concoct -t 60 --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b concoct_output
  merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv
  mkdir concoct_output/fasta_bins
  extract_fasta_bins.py final.contigs.fa concoct_output/clustering_merged.csv --output_path concoct_output/fasta_bins
done

conda deactivate



source activate das

for f in *_1_val_1.fq
do
  d=$r'/megahit_'${f/'_1_val_1.fq'/''}
  cd $d
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./concoct_output/fasta_bins -e fa > bins_concoct.tsv
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./maxbin2 -e fasta > bins_maxbin2.tsv
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./metabat -e fa > bins_metabat.tsv
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./metadecoder -e fasta > bins_metadecoder.tsv
  gunzip semibin/output_bins/*.gz
  /data/tools/miniforge3/envs/das/bin/Fasta_to_Contig2Bin.sh -i ./semibin/output_bins -e fa > bins_SemiBin2.tsv

  DAS_Tool -i bins_concoct.tsv,bins_maxbin2.tsv,bins_metabat.tsv,bins_metadecoder.tsv,bins_SemiBin2.tsv -l concoct,maxbin2,metabat,metadecoder,SemiBin2 -c final.contigs.fa -o das_res/run1 --write_bins --write_unbinned --write_bin_evals --threads 60

done

conda deactivate


