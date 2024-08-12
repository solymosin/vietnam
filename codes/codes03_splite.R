# R

library(sf)
library(tidyverse)
library(readxl)
library(tmap)
library(RColorBrewer)
library(xtable)
library(grid)
library(Cairo)

deg2dec = function(deg, min, sec){
    return(deg+min/60+sec/3600)
}

setwd('/home/sn/dev/aote/Para/Vietnam/vietnam_github/data')

spring_2023 = read_xlsx('++NĐT-Working-Samples 4 season 2022-2023.Coding2.7.5.2024.xlsx', sheet=1)
summer_2022 = read_xlsx('++NĐT-Working-Samples 4 season 2022-2023.Coding2.7.5.2024.xlsx', sheet=2)
autumn_2022 = read_xlsx('++NĐT-Working-Samples 4 season 2022-2023.Coding2.7.5.2024.xlsx', sheet=3)
winter_2022 = read_xlsx('++NĐT-Working-Samples 4 season 2022-2023.Coding2.7.5.2024.xlsx', sheet=4)

summer_2022 = summer_2022 |> select(Household, Village, Commune, Longitude, District, Province, `Animal types`, Breed, Roaming, `Age (year)`, Ana, Babe, Theile, T.evansi, Gender) |> mutate(y=2022, s='summer')

spring_2023 = spring_2023 |> select(Household, Village, Commune, Longitude, District, Provin, `Animal types`, Breed, Roaming, `Age (year)`, Ana, Babe, Theile, Tevansi, Gender) |> mutate(y=2023, s='spring')

autumn_2022 = autumn_2022 |> select(household, village, commune, longitude, district, province, `Animal type`, Breed, Roaming, `age (year)`, Ana, Babe, Theile, Tevansi, Gender) |> mutate(y=2022, s='autumn')

winter_2022 = winter_2022 |> select(Household, Village, Commune, Longitude, District, Province, `Animal types`, Breed, Roaming, `Age (year)`, Ana, Babe, Theile, Tevansi, Gender) |> mutate(y=2022, s='winter')

colnames(spring_2023) = colnames(summer_2022)
colnames(autumn_2022) = colnames(summer_2022)
colnames(winter_2022) = colnames(summer_2022)

wd = bind_rows(
summer_2022,
spring_2023 |> mutate(`Age (year)`=as.character(`Age (year)`)),
autumn_2022,
winter_2022 |> mutate(`Age (year)`=as.character(`Age (year)`))
)

wd = wd |> mutate(Longitude=gsub('°', '′', gsub('″', '', Longitude))) |> separate(Longitude, c('a','b'), sep='B', remove=F) |> mutate(a=str_trim(a), b=str_trim(gsub('Đ', '', b))) |> separate(a, c('a1', 'a2', 'a3'), sep='′', remove=F)  |> separate(b, c('b1', 'b2', 'b3'), sep='′', remove=F) |> mutate(y=deg2dec(as.numeric(a1),as.numeric(a2),as.numeric(a3)), x=deg2dec(as.numeric(b1),as.numeric(b2),as.numeric(b3)), y=ifelse(y<1, 20.9425267, y)) |> rename(Season=s)

provinces = st_read('../maps/gadm41_VNM_1.shp')
districts = st_read('../maps/gadm41_VNM_2.shp')
communes = st_read('../maps/gadm41_VNM_3.shp')
# |> rename(Commune=NAME_3, District=NAME_2, Province=NAME_1)
osm = st_read('../maps/gis_osm_places_free_1.shp')
vill = osm |> filter(fclass=='village')


inner_join(wd |> select(Province) |> unique(), provinces |> rename(Province=NAME_1))

inner_join(wd |> select(District) |> unique(), districts |> rename(District=NAME_2)) |> select(District) |> arrange(District)

wd = wd |> mutate(District=gsub('Định Hoá', 'Định Hóa', District))

wd |> select(Commune) |> unique() |> arrange(Commune)

left_join(wd |> select(Commune) |> unique(), communes |> mutate(Commune=NAME_3)) |> select(Commune, NAME_3) |> unique() |> arrange(Commune)

left_join(wd |> select(Commune) |> unique(), communes |> mutate(Commune=NAME_3)) |> select(Commune, NAME_3) |> unique() |> arrange(Commune) |> data.frame()

inner_join(wd |> mutate(Commune=gsub('Thụy Lâm', 'Thuỵ Lâm', gsub('Vân Hoà', 'Vân Hòa', Commune))) |> select(Commune) |> unique(), communes |> mutate(Commune=NAME_3)) |> select(Commune, NAME_3) |> unique() |> arrange(Commune) |> data.frame()

wd = wd |> mutate(Commune=gsub('Liên Hòa', 'Liên Hoà', gsub('Thụy Lâm', 'Thuỵ Lâm', gsub('Vân Hoà', 'Vân Hòa', Commune))))

wd = wd |> select(-c('a', 'a1', 'a2', 'a3', 'b', 'b1', 'b2', 'b3', 'x', 'y')) |> rename(Animal_type=`Animal types`, Age=`Age (year)`, Tevansi=T.evansi)

wd |> write_delim(file='wd.csv', delim=';')

SELECT gadm41_VNM_3*, wd.Babe FROM gadm41_VNM_3 INNER JOIN wd ON wd.Commune = gadm41_VNM_3.NAME_3;


