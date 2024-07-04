# R

library(sf)
library(tidyverse)
library(readxl)

setwd('/home/sn/dev/aote/Para/Vietnám')

dat = read_xlsx('3List of samples to Hung17.10.2022 Anapalsma is.xlsx')

# communes = st_read('gadm41_VNM_3.shp')
# communes |> filter(VARNAME_3=='Cat Ne' | )

districts  = st_read('gadm41_VNM_2.shp')
districts |> filter(VARNAME_2=='Cat Ne')

dat |> filter(!is.na(Province)) |> select(Province, District) |> unique()
# # A tibble: 6 × 2
#   Province    District
#   <chr>       <chr>
# 1 Thai Nguyen Dai Tu    VNM.56.1_1
# 2 Ha Noi      Thanh Tri VNM.27.28_1
# 3 Thai Nguyen Dinh Hoa   VNM.56.2_1
# 4 Ha Noi      Gia Lam   VNM.27.10_1
# 5 Ha Noi      Ba Vi    VNM.27.4_1
# 6 Son La      Song Ma  VNM.52.9_1


tmp = dat |> filter(!is.na(Province)) |> select(Province, District) |> unique() |> mutate(GID_2=c('VNM.56.1_1', 'VNM.27.28_1', 'VNM.56.2_1', 'VNM.27.10_1', 'VNM.27.4_1', 'VNM.52.9_1'))

dat |> rename(Sample_ID=2, No_Individuals=`No Individuals`, Blood_sample=`Blood sample`)

inner_join(
dat |> rename(Sample_ID=2, No_Individuals=`No Individuals`, Blood_sample=`Blood sample`) |> filter(!is.na(Sample_ID)),
tmp) |> write_csv(file='samples.csv')

inner_join(districts, tmp |> select(3)) |> st_write(driver='ESRI Shapefile', dsn='sample_districts', layer_options='ENCODING=UTF-8', delete_layer=T)


