# R

library(sf)
library(tidyverse)
library(readxl)
library(tmap)
library(RColorBrewer)
library(xtable)


setwd('/home/sn/dev/aote/Para/Vietnam/data')

dat = read_xlsx('+Results of 4 season NDT-HU-02-2022.xlsx', sheet=1)
# dat |> rename(id=1, Household=2, Village=3, Commune=4, pos=District, District=6, Province=7, `Animal types`=8, Breed=9, Roaming=10, Age=11, Gender=12) |> as.data.frame() |> head()
dat1 = dat |> rename(id=1, Household=2, Village=3, Commune=4, pos=District, District=6, Province=7, `Animal types`=8, Breed=9, Roaming=10, Age=11, Gender=12) |> mutate(season='summer')

dat = read_xlsx('+Results of 4 season NDT-HU-02-2022.xlsx', sheet=2) |> select(-1)
dat2 = dat |> rename(id=1, Household=2, Village=3, Commune=4, pos=5, District=6, Province=7, `Animal types`=9, Breed=10, Roaming=11, Age=12, Gender=14) |> mutate(season='autumn')

dat = read_xlsx('+Results of 4 season NDT-HU-02-2022.xlsx', sheet=3)
dat3 = dat |> rename(id=1, Household=2, Village=3, Commune=4, pos=5, District=6, Province=7, `Animal types`=8, Breed=9, Roaming=10, Age=11, Gender=12, Tevansi=T.evansi) |> mutate(season='winter')

dat = read_xlsx('+Results of 4 season NDT-HU-02-2022.xlsx', sheet=4)
dat4 = dat |> rename(id=1, Household=2, Village=3, Commune=4, pos=5, District=6, Province=7, `Animal types`=8, Breed=9, Roaming=10, Age=11, Gender=12, Tevansi=T.evansi) |> mutate(season='spring')

dat = bind_rows(dat1, dat2, dat3, dat4)

locs = dat |> select(pos) |> unique() |> separate(pos, c('lat', 'lon'), 'B', remove=F) |> mutate(lat=gsub('', '', gsub('″', '', lat)), lon=gsub(' ', '', gsub('″Đ', '', lon)))

deg2dec = function(deg, min, sec){
    return(deg+min/60+sec/3600)
}

dec = c()
for(i in 1:dim(locs)[1]){
  deg = as.numeric(unlist(strsplit(unlist(strsplit(locs$lat[i], '°')), '′')))
  dec = c(dec, deg2dec(deg[1], deg[2], deg[3]))
}
locs$y = dec
dec = c()
for(i in 1:dim(locs)[1]){
  deg = as.numeric(unlist(strsplit(unlist(strsplit(str_trim(locs$lon[i]), '°')), '′')))
  dec = c(dec, deg2dec(deg[1], deg[2], deg[3]))
}
locs$x = dec

locs$y[locs$y<1] = 20.9425267

dat = inner_join(dat, locs)

dat |> group_by(Province, `Animal types`, season) |> summarize(n=n()) |> spread(season, n) |> select(1,2,5,3,6,4)


dat |> group_by(Household, `Animal types`, season) |> summarize(n=n()) |> spread(season, n) |> select(1,2,5,3,6,4)

provinces = st_read('../maps/gadm41_VNM_1.shp')

communes = st_read('../maps/gadm41_VNM_3.shp') |> rename(Commune=NAME_3, District=NAME_2, Province=NAME_1)
communes = communes |> mutate(Commune=gsub('Liên Hoà', 'Liên Hòa', Commune))
communes = communes |> mutate(Commune=gsub('Thuỵ Lâm', 'Thụy Lâm', Commune))
communes = communes |> mutate(Commune=gsub('Vân Hòa', 'Vân Hoà', Commune))
communes$District[which(communes$District=='Định Hóa' & communes$Commune=='Đồng Thịnh')] = 'Định Hoá'

setwd('../reports')

dat |> group_by(Province, `Animal types`, season) |> summarize(n=n()) |> spread(season, n) |> select(1,2,5,3,6,4) |> xtable() |> print(include.rownames=F, booktabs=T)

inner_join(dat |> group_by(Province, District, Commune, season) |> summarize(n=n()) |> spread(season, n) %>% replace(is.na(.), 0) , communes) |> mutate(Commune=VARNAME_3) |> ungroup() |> select(-c(1,2)) |> select(1,4,2,5,3) |> arrange(Commune) |> xtable() |> print(include.rownames=F, booktabs=T)

# communes = communes |> mutate(District=gsub('Định Hóa', 'Định Hoá', District))

left_join(dat |> select(Province, District, Commune) |> unique(), communes) |> filter(is.na(GID_3)) |> select(Province, District, Commune) |> arrange(Commune)

smpld = inner_join(communes, dat |> select(Province, District, Commune) |> unique())
bb = st_bbox(smpld)

insetmap = tm_shape(provinces) + tm_polygons(col=gray.colors(30)[15], border.alpha=0.3) +
tm_compass(color.light='grey90', size=1, text.size=0.5, type='arrow', position=c('right', 'top')) +
tm_shape(st_as_sfc(bb)) + tm_borders(col='blue')
vp = grid::viewport(0.085, 0.69, width=0.5, height=0.6)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='yellow')
tmap_save(map, filename='map01.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
inner_join(communes, dat |> group_by(Province, District, Commune) |> summarize(helyn=n())) |> tm_shape() + tm_polygons(col='helyn', title='No. of samples')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map02.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,
dat |> filter(season=='summer') |> group_by(Province, District, Commune) |> summarize(helyn=n())) |> tm_shape() + tm_polygons(col='helyn', title='No. of samples')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map02_summer.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,
dat |> filter(season=='autumn') |> group_by(Province, District, Commune) |> summarize(helyn=n())) |> tm_shape() + tm_polygons(col='helyn', title='No. of samples')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map02_autumn.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,
dat |> filter(season=='winter') |> group_by(Province, District, Commune) |> summarize(helyn=n())) |> tm_shape() + tm_polygons(col='helyn', title='No. of samples')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map02_winter.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,
dat |> filter(season=='spring') |> group_by(Province, District, Commune) |> summarize(helyn=n())) |> tm_shape() + tm_polygons(col='helyn', title='No. of samples')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map02_spring.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,dat |> mutate(ds=Ana) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map03.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='summer')|> mutate(ds=Ana) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map03_summer.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='autumn')|> mutate(ds=Ana) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map03_autumn.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='winter')|> mutate(ds=Ana) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map03_winter.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='spring')|> mutate(ds=Ana) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map03_spring.pdf', insets_tm=insetmap, insets_vp=vp)


map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,dat |> mutate(ds=Babe) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map04.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='summer')|> mutate(ds=Babe) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map04_summer.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='autumn')|> mutate(ds=Babe) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map04_autumn.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='winter')|> mutate(ds=Babe) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map04_winter.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='spring')|> mutate(ds=Babe) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map04_spring.pdf', insets_tm=insetmap, insets_vp=vp)


map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,dat |> mutate(ds=Theile) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map05.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='summer')|> mutate(ds=Theile) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map05_summer.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='autumn')|> mutate(ds=Theile) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map05_autumn.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='winter')|> mutate(ds=Theile) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map05_winter.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='spring')|> mutate(ds=Theile) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map05_spring.pdf', insets_tm=insetmap, insets_vp=vp)



map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes,dat |> mutate(ds=Tevansi) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map06.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='summer')|> mutate(ds=Tevansi) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map06_summer.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='autumn')|> mutate(ds=Tevansi) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map06_autumn.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='winter')|> mutate(ds=Tevansi) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map06_winter.pdf', insets_tm=insetmap, insets_vp=vp)

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
smpld |> tm_shape() + tm_polygons(col='lightblue') +
inner_join(communes, dat  |> filter(season=='spring')|> mutate(ds=Tevansi) |> group_by(Province, District, Commune, ds) |> summarize(db=n()) |> spread(ds, db) |> mutate(prev=`1`/(`1`+`0`))) |> tm_shape() + tm_polygons(col='prev', title='Prevalence', style='cont')+ tm_layout(inner.margins=0, legend.position = c(0.15,0.69), legend.show=T, legend.bg.color='white', legend.bg.alpha=0.7)
tmap_save(map, filename='map06_spring.pdf', insets_tm=insetmap, insets_vp=vp)


prevs = bind_rows(
bind_rows(
dat |> group_by(`Animal types`, Ana) |> summarize(db=n()) |> spread(Ana, db) |> mutate(spec='anaplasma', season='all'),
dat |> filter(season=='summer') |> group_by(`Animal types`, Ana) |> summarize(db=n()) |> spread(Ana, db) |> mutate(spec='anaplasma', season='summer'),
dat |> filter(season=='autumn') |> group_by(`Animal types`, Ana) |> summarize(db=n()) |> spread(Ana, db) |> mutate(spec='anaplasma', season='autumn'),
dat |> filter(season=='winter') |> group_by(`Animal types`, Ana) |> summarize(db=n()) |> spread(Ana, db) |> mutate(spec='anaplasma', season='winter'),
dat |> filter(season=='spring') |> group_by(`Animal types`, Ana) |> summarize(db=n()) |> spread(Ana, db) |> mutate(spec='anaplasma', season='spring')
),
bind_rows(
dat |> group_by(`Animal types`, Babe) |> summarize(db=n()) |> spread(Babe, db) |> mutate(spec='babesia', season='all'),
dat |> filter(season=='summer') |> group_by(`Animal types`, Babe) |> summarize(db=n()) |> spread(Babe, db) |> mutate(spec='babesia', season='summer'),
dat |> filter(season=='autumn') |> group_by(`Animal types`, Babe) |> summarize(db=n()) |> spread(Babe, db) |> mutate(spec='babesia', season='autumn'),
dat |> filter(season=='winter') |> group_by(`Animal types`, Babe) |> summarize(db=n()) |> spread(Babe, db) |> mutate(spec='babesia', season='winter'),
dat |> filter(season=='spring') |> group_by(`Animal types`, Babe) |> summarize(db=n()) |> spread(Babe, db) |> mutate(spec='babesia', season='spring')
),
bind_rows(
dat |> group_by(`Animal types`, Theile) |> summarize(db=n()) |> spread(Theile, db) |> mutate(spec='theileria', season='all'),
dat |> filter(season=='summer') |> group_by(`Animal types`, Theile) |> summarize(db=n()) |> spread(Theile, db) |> mutate(spec='theileria', season='summer'),
dat |> filter(season=='autumn') |> group_by(`Animal types`, Theile) |> summarize(db=n()) |> spread(Theile, db) |> mutate(spec='theileria', season='autumn'),
dat |> filter(season=='winter') |> group_by(`Animal types`, Theile) |> summarize(db=n()) |> spread(Theile, db) |> mutate(spec='theileria', season='winter'),
dat |> filter(season=='spring') |> group_by(`Animal types`, Theile) |> summarize(db=n()) |> spread(Theile, db) |> mutate(spec='theileria', season='spring')
),
bind_rows(
dat |> group_by(`Animal types`, Tevansi) |> summarize(db=n()) |> spread(Tevansi, db) |> mutate(spec='Tevansi', season='all'),
dat |> filter(season=='summer') |> group_by(`Animal types`, Tevansi) |> summarize(db=n()) |> spread(Tevansi, db) |> mutate(spec='Tevansi', season='summer'),
dat |> filter(season=='autumn') |> group_by(`Animal types`, Tevansi) |> summarize(db=n()) |> spread(Tevansi, db) |> mutate(spec='Tevansi', season='autumn'),
dat |> filter(season=='winter') |> group_by(`Animal types`, Tevansi) |> summarize(db=n()) |> spread(Tevansi, db) |> mutate(spec='Tevansi', season='winter'),
dat |> filter(season=='spring') |> group_by(`Animal types`, Tevansi) |> summarize(db=n()) |> spread(Tevansi, db) |> mutate(spec='Tevansi', season='spring')
)
)

prevs |> mutate(prev=`1`/(`1`+`0`)) |> ggplot(aes(x=season, y=prev)) + geom_bar(stat='identity') + facet_grid(`Animal types` ~ spec) + xlab('') + ylab('Prevalence')
ggsave('fig_prev01.pdf', width=10, height=6)



#
#
#
# # communes = st_read('gadm41_VNM_3.shp')
# # communes |> filter(VARNAME_3=='Cat Ne' | )
#
# districts  = st_read('gadm41_VNM_2.shp')
# districts |> filter(VARNAME_2=='Cat Ne')
#
# dat |> filter(!is.na(Province)) |> select(Province, District) |> unique()
# # # A tibble: 6 × 2
# #   Province    District
# #   <chr>       <chr>
# # 1 Thai Nguyen Dai Tu    VNM.56.1_1
# # 2 Ha Noi      Thanh Tri VNM.27.28_1
# # 3 Thai Nguyen Dinh Hoa   VNM.56.2_1
# # 4 Ha Noi      Gia Lam   VNM.27.10_1
# # 5 Ha Noi      Ba Vi    VNM.27.4_1
# # 6 Son La      Song Ma  VNM.52.9_1
#
#
# tmp = dat |> filter(!is.na(Province)) |> select(Province, District) |> unique() |> mutate(GID_2=c('VNM.56.1_1', 'VNM.27.28_1', 'VNM.56.2_1', 'VNM.27.10_1', 'VNM.27.4_1', 'VNM.52.9_1'))
#
# dat |> rename(Sample_ID=2, No_Individuals=`No Individuals`, Blood_sample=`Blood sample`)
#
# inner_join(
# dat |> rename(Sample_ID=2, No_Individuals=`No Individuals`, Blood_sample=`Blood sample`) |> filter(!is.na(Sample_ID)),
# tmp) |> write_csv(file='samples.csv')
#
# inner_join(districts, tmp |> select(3)) |> st_write(driver='ESRI Shapefile', dsn='sample_districts', layer_options='ENCODING=UTF-8', delete_layer=T)
#
#
