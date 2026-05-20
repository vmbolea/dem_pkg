#' @title dem_tiles
#' @description Tiles of the Copernicus Digital Elevation Model
#' @format A data frame with 26475 rows and 3 variables:
#' \describe{
#'   \item{\code{filename_dem_30}}{Name of the 30 m file corresponding to the tile.}
#'   \item{\code{filename_dem_90}}{Name of the 30 m file corresponding to the tile.}
#'   \item{\code{geometry}}{Tile geometry.}
#'}
#' @details Modified from: [https://spacedata.copernicus.eu/collections/copernicus-digital-elevation-model](https://spacedata.copernicus.eu/collections/copernicus-digital-elevation-model). Direct link to the original file: [https://spacedata.copernicus.eu/documents/20123/121239/GEO1988-CopernicusDEM-RP-002_GridFile_I6.0.shp.zip](https://spacedata.copernicus.eu/documents/20123/121239/GEO1988-CopernicusDEM-RP-002_GridFile_I6.0.shp.zip)
"dem_tiles"

#' @title counties_sf
#' @description Sf data frame with several counties in Illinois and Indiana.
#' @format An sf data frame with 5 rows and 4 variables:
#' \describe{
#'   \item{\code{country}}{Country name.}
#'   \item{\code{state}}{State name.}
#'   \item{\code{county}}{County name.}
#'   \item{\code{geom}}{County geometry.}
#'}
"counties_sf"

#' @title jacetania
#' @description Sf data frame with one region in Aragon(Spain).
#' @format An sf data frame with 1 rows and 14 variables:
#' \describe{
#'   \item{\code{objectid}}{ID object.}
#'   \item{\code{c_comarca}}{Region code.}
#'   \item{\code{d_comarca}}{Region name.}
#'   \item{\code{sum_sup_of}}{Region surface in km2.}
#'   \item{\code{fonetica}}{Phonetics of the name.}
#'   \item{\code{ccomarca}}{Region code.}
#'   \item{\code{scale}}{Scale.}
#'   \item{\code{dcomarca1}}{Region name.}
#'   \item{\code{uri_aod}}{URL data.}
#'   \item{\code{on_date}}{Beggining date.}
#'   \item{\code{off_date}}{Ending date.}
#'   \item{\code{fecha_ini}}{Beggining date.}
#'   \item{\code{fecha_fin}}{Ending date.}
#'   \item{\code{geom}}{County geometry.}
#'}
"jacetania"
