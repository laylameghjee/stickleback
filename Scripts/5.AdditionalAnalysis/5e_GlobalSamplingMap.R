# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        Global Sampling Map        #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#library packages 
library(ggplot2)
library(dplyr)
library(readxl)
library(maps)

#setting directories 
metadata <- "/gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xlsx"
outdir <- "/gpfs01/home/mbxlm9/Stickle/plots"

#load meta
meta <- readxls(metadata, sheet = "template")

#grouping into freshwater and marine 
meta_eco <- meta_eco %>%
	mutate( Environment = case_when(
		ecotype %in% c("lake", "stream") ~ "Freshwater",
		ecotype == "marine" ~ "Marine",
		TRUE ~ "Unknown")) %>%
		filter(!is.na(decimalLongitude), !is.na(decimalLatitude))

#loading map
world <- map_data("world")

#potting
sample_map <- ggplot() +
			#mapp
			geom_polygon( data = world, aes( x= long, y= lat, group = group), 
				fill = "grey95", colour = "grey60", linewidth = 0.3) + 
			#region boundaries 
			geom_vline(xintercept = c(-100, -30, 100), linetype = "dashed", linewidth = 0.5) +
			#sampling locations 
			geom_point(data = meta, aes(x = decimalLongitude, y = decimalLatitude, colour = ecotype),
				size = 1.6, alpha = 0.35) + 
			scale_colour_manual (values = c ( "Freshwater" = "dodgerblue", "Marine" = "cadetblue2", "Unknown" = "olivedrab3")) + 
			#geographic region labels 
			annotate ("text", x = -140, y = -64, label = "East Pacific", fontface = "bold", size = 3.5) +
			annotate ("text", x = -65, y = -64, label = "West Atlantic", fontface = "bold", size = 3.5) +
			annotate ("text", x = -35, y = -64, label = "East Atlantic", fontface = "bold", size = 3.5) +
			annotate ("text", x = 140, y = -64, label = "West Pacific", fontface = "bold", size = 3.5) +
			#axis labels
			labs( x= "Longitude", y = "Latitude", colour = "Ecotype") +
			#cutting off antartica 
			coord_quickmaps (xlim = c(-180, 180), ylim = c(-60, 85)) + 
			#formatting 
			theme_classic(base_size = 14) +
			theme(axis.title = element_text( size = 13),
                axis.text = element_text( size = 10),
                legend.title = element_text( size = 12),
                legend.text = element_text( size = 11),
                legend.position = "right") 

#saving plot 
ggsave(file.path(outdir, "sampling_map.png"), sample_map, width = 12, height = 7, dpi = 600)







