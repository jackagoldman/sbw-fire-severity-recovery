# Study area figure: maps A-C, legend and sample size table
# Saveed separately as SVG to assemble as a panel in Inkscape.

library(dplyr)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(svglite)
library(gridExtra)
library(grid)

source("utils/load_data.R")

output_dir <- "plots/maps/map_components"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# Shared styling 

# Canada Lambert
map_crs <- 3348

# ColorBrewer colour-blind-safe colours
history_colours <- c("0" = "#E66101", "1" = "#5E3C99")
history_labels <- c("0" = "Non-defoliated", "1" = "Defoliated")

land_fill <- "grey85"
border_colour <- "black"
border_width <- 0.3
point_size <- 1.2

# Boundaries 

canada <- ne_states(country = "Canada", returnclass = "sf") %>%
  st_transform(map_crs)

ontario <- canada %>%
  filter(name == "Ontario")

# Map function 

make_study_map <- function(boundary, fires) {
  # Shuffle so neither group is systematically drawn on top of the other
  set.seed(123)
  fires <- fires[sample(nrow(fires)), ] %>%
    st_transform(map_crs)

  ggplot() +
    geom_sf(data = boundary, fill = land_fill, color = border_colour,
            linewidth = border_width) +
    geom_sf(data = fires, aes(color = factor(history)), size = point_size,
            shape = 16) +
    scale_color_manual(values = history_colours, guide = "none") +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "transparent", color = NA),
      panel.background = element_rect(fill = "transparent", color = NA)
    )
}

save_svg <- function(plot, filename, width, height) {
  ggsave(file.path(output_dir, filename), plot = plot, device = svglite,
         width = width, height = height, units = "in", bg = "transparent")
}

# Maps 

save_svg(make_study_map(canada, h90.sf),
         "map_A_canada_all_fires.svg", width = 8, height = 7)
save_svg(make_study_map(ontario, m.data.sev_sf),
         "map_B_ontario_severity.svg", width = 6, height = 6)
save_svg(make_study_map(ontario, m.data.rec_sf),
         "map_C_ontario_recovery.svg", width = 6, height = 6)

# Legend 

legend_data <- data.frame(
  history = names(history_colours),
  label = unname(history_labels[names(history_colours)]),
  y = c(2, 1)
)

legend_plot <- ggplot(legend_data, aes(x = 1, y = y)) +
  geom_point(aes(color = history), size = 3, shape = 16) +
  geom_text(aes(x = 1.15, label = label), hjust = 0, size = 3.5) +
  scale_color_manual(values = history_colours, guide = "none") +
  coord_cartesian(xlim = c(0.9, 3), ylim = c(0.5, 2.5)) +
  theme_void()

save_svg(legend_plot, "legend.svg", width = 2, height = 0.7)

# Sample size table 

count_fires <- function(fires, panel, dataset) {
  fires <- st_drop_geometry(fires)
  data.frame(
    Panel = panel,
    Dataset = dataset,
    `Non-defoliated` = sum(fires$history == 0),
    Defoliated = sum(fires$history == 1),
    Total = nrow(fires),
    check.names = FALSE
  )
}

sample_sizes <- bind_rows(
  count_fires(h90.sf, "A", "All fires"),
  count_fires(m.data.sev_sf, "B", "Matched: severity"),
  count_fires(m.data.rec_sf, "C", "Matched: recovery")
)

write.csv(sample_sizes, file.path(output_dir, "sample_size_table.csv"),
          row.names = FALSE)

table_grob <- tableGrob(sample_sizes, rows = NULL, theme = ttheme_minimal())

svglite(file.path(output_dir, "sample_size_table.svg"), width = 6, height = 1.4)
grid.draw(table_grob)
dev.off()

print(sample_sizes)
