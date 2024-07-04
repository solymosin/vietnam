# R

library(sf)
library(tidyverse)
library(readxl)
library(tmap)
library(RColorBrewer)
library(xtable)
library(grid)
library(Cairo)

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
districts = st_read('../maps/gadm41_VNM_2.shp')
communes = st_read('../maps/gadm41_VNM_3.shp') |> rename(Commune=NAME_3, District=NAME_2, Province=NAME_1)
communes = communes |> mutate(Commune=gsub('Liên Hoà', 'Liên Hòa', Commune))
communes = communes |> mutate(Commune=gsub('Thuỵ Lâm', 'Thụy Lâm', Commune))
communes = communes |> mutate(Commune=gsub('Vân Hòa', 'Vân Hoà', Commune))
communes$District[which(communes$District=='Định Hóa' & communes$Commune=='Đồng Thịnh')] = 'Định Hoá'

setwd('../reports')
#
# dat |> group_by(Province, `Animal types`, season) |> summarize(n=n()) |> spread(season, n) |> select(1,2,5,3,6,4) |> xtable() |> print(include.rownames=F, booktabs=T)
#
# inner_join(dat |> group_by(Province, District, Commune, season) |> summarize(n=n()) |> spread(season, n) %>% replace(is.na(.), 0) , communes) |> mutate(Commune=VARNAME_3) |> ungroup() |> select(-c(1,2)) |> select(1,4,2,5,3) |> arrange(Commune) |> xtable() |> print(include.rownames=F, booktabs=T)

communes = communes |> mutate(District=gsub('Định Hóa', 'Định Hoá', District))

# left_join(dat |> select(Province, District, Commune) |> unique(), communes) |> filter(is.na(GID_3)) |> select(Province, District, Commune) |> arrange(Commune)

smpld = inner_join(communes, dat |> select(Province, District, Commune) |> unique())


communes |> filter(VARNAME_3=="Thanh Tri", Province=='Hà Nội') |> select(VARNAME_3) |> rename(District=1)

dstcts = inner_join(districts,
tibble(
VARNAME_2=c(
'Ba Vi',
'Dai Tu',
'Dinh Hoa',
'Dong Anh',
'Song Ma',
'Thanh Tri',
'Van Ho',
'Vo Nhai'),
'E. minasensis'=c(
'-',
'-',
'-',
'+',
'-',
'+',
'+',
'-')
)) |> filter(GID_2!='VNM.51.9_1')


# dstcts = inner_join(districts,
# matrix(c(
# "Ba Vi",'-',
# "Dai Tu",'-',
# "Dinh Hoa",'-',
# "Dong Anh",'+',
# "Gia Lam",'-',
# "Phu Luong",'-',
# "Song Ma", '-',
# # 'Thanh Tri', '+',
# "Van Ho", '+',
# "Vo Nhai", '-'
# ), nc=2, byrow=T) |> as_tibble() |> rename('VARNAME_2'=1, 'E. minasensis'=2)
# )

bb = st_bbox(dstcts)
bb[3] = bb[3]+0.5
bb[1] = bb[1]-0.1

# insetmap = tm_shape(provinces) + tm_polygons(col=gray.colors(30)[15], border.alpha=0.3) +
# tm_compass(color.light='grey90', size=1, text.size=0.5, type='arrow', position=c('right', 'top')) +
# tm_shape(st_as_sfc(bb)) + tm_borders(col='blue')+
#   tm_layout(inner.margins = c(0.04,0.04,0.04,0.04), outer.margins=c(0,0,0,0))
# vp = grid::viewport(0.085, 0.69, width=0.5, height=0.6)
#
# tmap_save(map, filename='map_RO.pdf', insets_tm=insetmap, insets_vp=vp)
#
# # xy <- st_bbox(sg)
# asp <- (bb$ymax - bb$ymin)/(bb$xmax - bb$xmin)
#
# xy <- st_bbox(provinces)
# asp2 <- (xy$xmax - xy$xmin)/(xy$ymax - xy$ymin)
# w <- 0.25
# h <- asp2 * w
# vp <- viewport(x=0.985, y=0.585, width = w, height=h, just=c("right", "top"))
# tmap_save(map, filename='map_RO.pdf', insets_tm=insetmap, insets_vp=vp)
#
# tmap_save(map,filename="dist2nat2000.png",
#           dpi=100, insets_tm=insetmap, insets_vp=vp,
#           height=asp*91, width=91, units="mm")
#
#
# vp = grid::viewport(0.085, 0.69, width=0.5, height=0.6)

# "Ba Vì", "Ba Vi"
# "Đại Từ", "Dai Tu"
# "Định Hoá", "Dinh Hoa"
# "Đông Anh", "Dong Anh"
# "Gia Lâm", "Gia Lam"
# "Phú Lương", "Phu Luong"
# "Sông Mã", "Song Ma"
# "Vân Hồ", "Van Ho"
# "Võ Nhai", "Vo Nhai"

insetmap = tm_shape(provinces) + tm_polygons(col=gray.colors(30)[15], border.alpha=0.3, fill_alpha=0.5) +
tm_compass(color.light='grey90', size=1.5, text.size=0.75, type='arrow', position=c(0.73, 0.99)) +
tm_shape(st_as_sfc(bb)) + tm_borders(col='blue') + tm_layout(bg.color='white')


map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
inner_join(provinces, tibble(VARNAME_1=c('Thai Nguyen', 'Son La', 'Ha Noi'))) |> rename(Province=VARNAME_1) |> tm_shape() + tm_polygons(fill='Province', fill.legend = tm_legend(orientation='landscape',
position = tm_pos_in(0.18, 0.99), frame=T, bg.color='white', bg.alpha=0.1))

CairoPDF('map_RO01.pdf', width=9, height=4.5)
map
print(insetmap, vp = grid::viewport(0.905, 0.55, width=0.4, height=0.6))
graphics.off()

map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
# inner_join(provinces, tibble(VARNAME_1=c('Thai Nguyen', 'Son La', 'Ha Noi'))) |> rename(Province=VARNAME_1) |> tm_shape() + tm_polygons(fill='Province', fill.legend = tm_legend(
# position = tm_pos_in(0.15, 0.99), frame=T, bg.color='white', bg.alpha=0.1)) +
dstcts |> tm_shape() + tm_polygons(fill='E. minasensis', fill.scale=tm_scale_categorical(values=c(brewer.pal(9,'Greens')[4], brewer.pal(9,'Reds')[7])),, fill.legend = tm_legend(orientation='landscape',
position = tm_pos_in(0.0, 0.99), frame=T, bg.color='white', bg.alpha=0.1))

CairoPDF('map_RO02.pdf', width=9, height=4.5)
map
print(insetmap, vp = grid::viewport(0.905, 0.55, width=0.4, height=0.6))
graphics.off()


map = provinces |> tm_shape(bbox=bb) + tm_polygons() +
inner_join(provinces, tibble(VARNAME_1=c('Thai Nguyen', 'Son La', 'Ha Noi'))) |> rename(Province=VARNAME_1) |> tm_shape() + tm_polygons(fill='Province', fill.legend = tm_legend(
position = tm_pos_in(0.2, 0.99), frame=T, bg.color='white', bg.alpha=0.1)) +
dstcts |> tm_shape() + tm_polygons(fill='E. minasensis', fill.scale=tm_scale_categorical(values=c(brewer.pal(9,'Greens')[6], brewer.pal(9,'Reds')[7])),, fill.legend = tm_legend(orientation='landscape',
position = tm_pos_in(0.35, 0.99), frame=T, bg.color='white', bg.alpha=0.1))

CairoPDF('map_RO03.pdf', width=9, height=4.5)
map
print(insetmap, vp = grid::viewport(0.905, 0.55, width=0.4, height=0.6))
graphics.off()


