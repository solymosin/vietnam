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

wd = wd |> mutate(Longitude=gsub('°', '′', gsub('″', '', Longitude))) |> separate(Longitude, c('a','b'), sep='B', remove=F) |> mutate(a=str_trim(a), b=str_trim(gsub('Đ', '', b))) |> separate(a, c('a1', 'a2', 'a3'), sep='′', remove=F)  |> separate(b, c('b1', 'b2', 'b3'), sep='′', remove=F) |> mutate(y=deg2dec(as.numeric(a1),as.numeric(a2),as.numeric(a3)), x=deg2dec(as.numeric(b1),as.numeric(b2),as.numeric(b3)), y=ifelse(y<1, 20.9425267, y))

provinces = st_read('../maps/gadm41_VNM_1.shp')
districts = st_read('../maps/gadm41_VNM_2.shp')
communes = st_read('../maps/gadm41_VNM_3.shp') |> rename(Commune=NAME_3, District=NAME_2, Province=NAME_1)
osm = st_read('../maps/gis_osm_places_free_1.shp')
vill = osm |> filter(fclass=='village')

# communes = communes |> mutate(Commune=gsub('Liên Hoà', 'Liên Hòa', Commune))
# communes = communes |> mutate(Commune=gsub('Thuỵ Lâm', 'Thụy Lâm', Commune))
# communes = communes |> mutate(Commune=gsub('Vân Hòa', 'Vân Hoà', Commune))
# communes$District[which(communes$District=='Định Hóa' & communes$Commune=='Đồng Thịnh')] = 'Định Hoá'

#
# provinces |> pull(NAME_1) |> sort()
# wd |> select(Province) |> unique()
#
# districts |> pull(NAME_1) |> unique() |> sort()
# wd |> select(District) |> unique()
#
# wd |> select(Commune) |> unique()
# communes |> pull(Commune) |> unique() |> sort()
#
# wd |> select(Village) |> unique()

setwd('../results/maps')


wd_province = inner_join(communes, wd |> select(Province) |> unique()) |> mutate(Province=gsub('Sơn La', 'Son La',gsub('Thái Nguyên', 'Thai Nguyen', gsub('Hà Nội', 'Ha Noi', Province))))

left_join(wd |> select(Commune) |> unique(), wd_province) |> select(Commune, Province) |> filter(is.na(Province))
sort(wd_province$Commune)
#
#   Commune  Province
#   <chr>    <chr>
# 1 Vân Hoà  NA      "Vân Hòa"
# 2 Thụy Lâm NA      "Thuỵ Lâm"
# 3 Liên Hòa "Liên Hoà"
wd_province = wd_province |> mutate(Commune=gsub('Liên Hoà', 'Liên Hòa', gsub('Thuỵ Lâm', 'Thụy Lâm', gsub('Vân Hòa', 'Vân Hoà', Commune))))



bb = st_bbox(wd_province)
bb[3] = bb[3]+0.5
bb[1] = bb[1]-0.1

insetmap = tm_shape(provinces) + tm_polygons(col=gray.colors(30)[15], border.alpha=0.3, fill_alpha=0.5) +
tm_compass(color.light='grey90', size=1.5, text.size=0.75, type='arrow', position=c(0.73, 0.99)) +
tm_shape(st_as_sfc(bb)) + tm_borders(col='blue') + tm_layout(bg.color='white')

map = provinces |> tm_shape(bbox=bb) + tm_borders() +
wd_province |> tm_shape() + tm_polygons('Province', lwd=0.2, fill.legend = tm_legend(
# orientation='landscape',
position = tm_pos_in(0.375, 0.99), frame=T, bg.color='white', bg.alpha=0.1))

CairoPDF('map_study_region.pdf', width=9, height=4.5)
map
print(insetmap, vp = grid::viewport(0.905, 0.55, width=0.4, height=0.6))
graphics.off()


wd_commune = inner_join(wd_province, wd, by='Commune')

map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_province, wd |> group_by(Commune) |> summarize(n=n()), by='Commune') |> tm_shape() + tm_polygons('n', lwd=0.5, fill.scale = tm_scale_intervals(values='Blues', style='fixed', breaks=c(seq(41,120,by=10),120)),fill.legend = tm_legend(
# orientation='landscape',
title='Sample size',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1))

CairoPDF('map_sample_size_4season.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()


map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_province, wd |> filter(s=='spring') |> group_by(Commune) |> summarize(n=n()), by='Commune') |> tm_shape() + tm_polygons('n', lwd=0.5, fill.scale = tm_scale_intervals(values='Blues', style='fixed', breaks=c(seq(41,120,by=10),120)),fill.legend = tm_legend(
# orientation='landscape',
title='Sample size',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1))
CairoPDF('map_sample_size_spring.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_province, wd |> filter(s=='summer') |> group_by(Commune) |> summarize(n=n()), by='Commune') |> tm_shape() + tm_polygons('n', lwd=0.5, fill.scale = tm_scale_intervals(values='Blues', style='fixed', breaks=c(seq(41,120,by=10),120)),fill.legend = tm_legend(
# orientation='landscape',
title='Sample size',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1))
CairoPDF('map_sample_size_summer.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_province, wd |> filter(s=='autumn') |> group_by(Commune) |> summarize(n=n()), by='Commune') |> tm_shape() + tm_polygons('n', lwd=0.5, fill.scale = tm_scale_intervals(values='Blues', style='fixed', breaks=c(seq(41,120,by=10),120)),fill.legend = tm_legend(
# orientation='landscape',
title='Sample size',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1))
CairoPDF('map_sample_size_autumn.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_province, wd |> filter(s=='winter') |> group_by(Commune) |> summarize(n=n()), by='Commune') |> tm_shape() + tm_polygons('n', lwd=0.5, fill.scale = tm_scale_intervals(values='Blues', style='fixed', breaks=c(seq(41,120,by=10),120)), fill.legend = tm_legend(
# orientation='landscape',
title='Sample size',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1))
CairoPDF('map_sample_size_winter.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()



map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_commune, wd |> group_by(Commune, Ana) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Ana, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF('map_sample_Ana_4season.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

seasons = c('spring', 'summer', 'autumn', 'winter')
for(seas in seasons){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
left_join(wd_commune, wd |> filter(s==seas) |> group_by(Commune, Ana) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Ana, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF(paste0('map_sample_Ana_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}


map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_commune, wd |> group_by(Commune, Babe) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Babe, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF('map_sample_Babe_4season.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

seasons = c('spring', 'summer', 'autumn', 'winter')
for(seas in seasons){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
left_join(wd_commune, wd |> filter(s==seas) |> group_by(Commune, Babe) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Babe, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF(paste0('map_sample_Babe_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}


map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_commune, wd |> group_by(Commune, Theile) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Theile, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF('map_sample_Theile_4season.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

seasons = c('spring', 'summer', 'autumn', 'winter')
for(seas in seasons){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
left_join(wd_commune, wd |> filter(s==seas) |> group_by(Commune, Theile) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Theile, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF(paste0('map_sample_Theile_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}


map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(wd_commune, wd |> group_by(Commune, T.evansi) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=T.evansi, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF('map_sample_T.evansi_4season.pdf', width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

seasons = c('spring', 'summer', 'autumn', 'winter')
for(seas in seasons){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
left_join(wd_commune, wd |> filter(s==seas) |> group_by(Commune, T.evansi) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=T.evansi, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3)), by='Commune')  |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', label.na='NA', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.005, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=35))
CairoPDF(paste0('map_sample_T.evansi_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}



mogrify -density 600 -format jpg *.pdf
mkdir pdf
mv *.pdf pdf
mkdir jpg
mv *.jpg jpg


setwd('../WP5.2')

specs = wd |> pull(`Animal types`) |> unique() |> sort()
seasons = c('spring', 'summer', 'autumn', 'winter')


path='Ana'
seas = '4season'
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> group_by(Province, Ana) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Ana, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

for(spec in specs){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> filter(`Animal types`==spec) |> group_by(Province, Ana) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Ana, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}


for(seas in seasons){
  map = provinces |> tm_shape(bbox=bb) + tm_borders() +
  inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas) |> group_by(Province, Ana) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Ana, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
  orientation='landscape',
  title='Prevalence',
  position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
  CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
  print(map)
  print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
  graphics.off()
  for(spec in specs){
    map = provinces |> tm_shape(bbox=bb) + tm_borders() +
    inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas, `Animal types`==spec) |> group_by(Province, Ana) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Ana, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
    orientation='landscape',
    title='Prevalence',
    position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
    CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
    print(map)
    print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
    graphics.off()
  }
}

path='Babe'
seas = '4season'
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> group_by(Province, Babe) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Babe, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

for(spec in specs){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> filter(`Animal types`==spec) |> group_by(Province, Babe) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Babe, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}


for(seas in seasons){
  map = provinces |> tm_shape(bbox=bb) + tm_borders() +
  inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas) |> group_by(Province, Babe) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Babe, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
  orientation='landscape',
  title='Prevalence',
  position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
  CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
  print(map)
  print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
  graphics.off()
  for(spec in specs){
    map = provinces |> tm_shape(bbox=bb) + tm_borders() +
    inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas, `Animal types`==spec) |> group_by(Province, Babe) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Babe, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
    orientation='landscape',
    title='Prevalence',
    position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
    CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
    print(map)
    print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
    graphics.off()
  }
}


path='Theile'
seas = '4season'
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> group_by(Province, Theile) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Theile, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

for(spec in specs){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> filter(`Animal types`==spec) |> group_by(Province, Theile) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Theile, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}


for(seas in seasons){
  map = provinces |> tm_shape(bbox=bb) + tm_borders() +
  inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas) |> group_by(Province, Theile) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Theile, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
  orientation='landscape',
  title='Prevalence',
  position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
  CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
  print(map)
  print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
  graphics.off()
  for(spec in specs){
    map = provinces |> tm_shape(bbox=bb) + tm_borders() +
    inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas, `Animal types`==spec) |> group_by(Province, Theile) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=Theile, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
    orientation='landscape',
    title='Prevalence',
    position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
    CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
    print(map)
    print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
    graphics.off()
  }
}

path='T.evansi'
seas = '4season'
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> group_by(Province, T.evansi) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=T.evansi, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()

for(spec in specs){
map = provinces |> tm_shape(bbox=bb) + tm_borders() +
inner_join(provinces |> rename(Province=NAME_1), wd |> filter(`Animal types`==spec) |> group_by(Province, T.evansi) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=T.evansi, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
orientation='landscape',
title='Prevalence',
position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
print(map)
print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
graphics.off()
}

for(seas in seasons){
  map = provinces |> tm_shape(bbox=bb) + tm_borders() +
  inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas) |> group_by(Province, T.evansi) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=T.evansi, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
  orientation='landscape',
  title='Prevalence',
  position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
  CairoPDF(paste0('map_province_', path,'_', seas,'.pdf'), width=9, height=4.5)
  print(map)
  print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
  graphics.off()
  for(spec in specs){
    map = provinces |> tm_shape(bbox=bb) + tm_borders() +
    inner_join(provinces |> rename(Province=NAME_1), wd |> filter(s==seas, `Animal types`==spec) |> group_by(Province, T.evansi) |> summarize(n=n()) |> ungroup() |> pivot_wider(names_from=T.evansi, values_from=n) |> mutate(prev=100*`1`/(`1`+`0`)) |> select(-c(2,3))) |> tm_shape() + tm_polygons('prev', lwd=0.5, fill.scale = tm_scale_continuous(values='Reds', limits=c(0,100)), fill.legend = tm_legend(
    orientation='landscape',
    title='Prevalence',
    position = tm_pos_in(0.22, 0.99), frame=T, bg.color='white', bg.alpha=0.1, width=23)) +
tm_text('VARNAME_1')
    CairoPDF(paste0('map_province_', path,'_', seas,'_', spec,'.pdf'), width=9, height=4.5)
    print(map)
    print(insetmap, vp = grid::viewport(0.905, 0.625, width=0.4, height=0.6))
    graphics.off()
  }
}

mogrify -density 600 -format jpg *.pdf
mkdir pdf
mkdir jpg
mv *.pdf pdf
mv *.jpg jpg


inner_join(provinces |> rename(Province=NAME_1), wd |> select(Province) |> unique())

st_within(inner_join(provinces |> rename(Province=NAME_1), wd |> select(Province) |> unique()), vill, sparse=F)
vill_study = vill[which(st_within(vill, inner_join(provinces |> rename(Province=NAME_1), wd |> select(Province) |> unique()), sparse=F) |> rowSums()==1),]

inner_join(provinces |> rename(Province=NAME_1), wd |> select(Province) |> unique()) |> tm_shape() + tm_borders() +
communes |> tm_shape() + tm_borders() +
vill |> tm_shape() + tm_dots()

provinces |> tm_shape(bbox=bb) + tm_borders()


communes[which(st_overlaps(inner_join(provinces |> rename(Province=NAME_1), wd |> select(Province) |> unique()), communes, sparse=F) |> rowSums()==1),]

inner_join(
communes,
inner_join(provinces |> rename(Province=NAME_1), wd |> select(Province) |> unique()) |> select(Province) |> st_drop_geometry()
) |> tm_shape() + tm_borders() +
vill |> tm_shape() + tm_dots()

cm = inner_join(
communes,
inner_join(provinces |> rename(Province=NAME_1), wd |> select(Province) |> unique()) |> select(Province) |> st_drop_geometry()
)

m = st_within(vill, cm, sparse=F)

vn = vill |> select(name) |> st_drop_geometry() |> as_tibble()

js = which(colSums(m)>0)
j = js[1]
i = which(m[,j])
tab = tibble(cid=j,vid=i,Commune=cm$Commune[j], Village=vn$name[i])
for(j in js){
  i = which(m[,j])
  tab = bind_rows(tab, tibble(cid=j,vid=i,Commune=cm$Commune[j], Village=vn$name[i]))
}
tab = tab |> unique()


