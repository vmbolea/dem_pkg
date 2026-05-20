# dem

## Summary

R package to download tiles of the  [Copernicus Global Digital Elevation Model at 30 or 90m resolution](https://spacedata.copernicus.eu/collections/copernicus-digital-elevation-model) from the [AWS Open Data Registry](https://registry.opendata.aws/copernicus-dem/).

## Requirements

The tool `aws cli` must be installed in the system. To check you have access to the data, please run:

```bash
aws s3 ls --no-sign-request s3://copernicus-dem-90m/
```

This command should return a long list of files with names like "PRE Copernicus_DSM_COG_30_S90_00_W169_00_DEM"

## Install

```r
remotes::install_github(
  repo = "vmbolea/dem_pkg",
  ref = "main",
  auth_token = "your_github_PAT",
  dependencies = TRUE,
  force = TRUE
)
```
## Usage

```r
library(dem)
library(terra)

#subset one county
jacetania <- jacetania |>
  sf::st_set_geometry("geom")


#download dem tiles for the county
dem <- dem_download(
  polygon = jacetania,
  resolution = 30,
  output = "raster"
)

#plot dem and polygons
plot(dem)
lines(terra::vect(jacetania))

#compute topographic indicators
topography <- dem_indicators(
  dem = dem
)

#plot topography
plot(topography)
```
