# Spruce Budworm Effects on Wildfire Burn Severity and Post-fire Spectral Recovery


Code and data for:

Goldman, JA; Fortin, M-J; James, PMA. Spruce Budworm defoliation legacies shape wildfire burn severity and post-fire spectral recovery in boreal forests

This repository calculates...

## Repository structure

| Folder              | Contents                                                                                                                                                                                                |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `analysis/`       |                                                        |
| `plots/`          | Scripts for the figures, plus the rendered figures (`supplementary/`, `map/`)                                                                                                            |
| `data/`           |  All Datasets used in analyses                                                                     |
| `results/`        | Tables and models from analyses (`all_fires/`, `intermediate/` , `subgroup/`)                                                                                                                                                                    |
|  `utils/`         | Functions used in the analysis and scripts used to load data                                                                                                                                                                                                        |

## Reproducing the analysis

The statistical analysis and most figures run from the included data:

1. Open R in the repository root (paths use the `here` package).
2. Run the scripts in `analysis/`, then the plotting scripts in `plots/`.


## R packages

dplyr, ggplot2, matchIt, paleteer, sensemakr, sf, svglite, rnaturalearth, rnaturalearthdata, gridExtra, grid, pwr, MuMIn, car, marginaleffects

## License

CC-BY-4.0 license
