#' @title Download Tiles of the Copernicus Digital Elevation Model.
#' @description
#' REQUIREMENTS: This function requires `aws cli` installed in your system. To check that you have acces to the data you can run `aws s3 ls --no-sign-request s3://copernicus-dem-90m/`.
#' Data sources:
#' \itemize{
#'   \item Copernicus: [https://spacedata.copernicus.eu/collections/copernicus-digital-elevation-model](https://spacedata.copernicus.eu/collections/copernicus-digital-elevation-model).
#'   \item Open Data AWS: [https://registry.opendata.aws/copernicus-dem/](https://registry.opendata.aws/copernicus-dem/).
#' }
#' @param polygon (required, sf data frame) area to download, in CRS 4326. Default: NULL.
#' @param resolution (required, integer) Either 30 or 90 meters resolution. Default: 30
#' @param folder (optional, character string) Name of the folder where to download the tiles of the digital elevation model. Default: "dem_tiles".
#' @param output (optional, output format) Either "vrt" for a file path to an virtual raster file with all downloaded tiles, or "raster" for a terra SpatRaster object. Default: "vrt"
#' @param quiet (optional, logical) If TRUE all messages are suppressed. Set to FALSE for debugging. Default: TRUE
#' @param sequential_download (optional, logical) If TRUE, tiles are downloaded sequentially. Set to TRUE for debugging. Default: FALSE
#' @examples
#' if(interactive()){
#' 
#'library(dem)
#'library(terra)
#'
#'#subset one county
#'newton <- counties_sf[counties_sf$county == "Newton", ]
#'
#'#download dem tiles for the county
#'dem <- dem_download(
#'  polygon = newton,
#'  resolution = 90,
#'  output = "raster"
#')
#'
#'#plot dem and polygons
#'plot(dem)
#'lines(terra::vect(newton))
#'
#'}
#'
#' @export
#' @autoglobal
dem_download <- function(
    polygon = NULL,
    resolution = 30,
    folder = "dem_tiles",
    output = "vrt",
    quiet = TRUE,
    sequential_download = FALSE
){
  
  Sys.setenv(AWS_RETRY_MODE="adaptive")
  Sys.setenv(AWS_MAX_ATTEMPTS=10)
  
  output <- match.arg(
    arg = output,
    choices = c("vrt", "raster"),
    several.ok = FALSE
  )
  
  #setting column names
  column_name <- "filename_dem_30"
  bucket_name <- "s3://copernicus-dem-30m"
  
  if(resolution == 90){
    column_name <- "filename_dem_90"
    bucket_name <- "s3://copernicus-dem-90m"
  }
  
  if(!dir.exists(folder)){
    dir.create(folder)
  }
  
  sf::sf_use_s2(FALSE) |>
    suppressWarnings() |> 
    suppressMessages()
  
 
  #set to same crs
  dem_tiles <- dem::dem_tiles |>
    sf::st_set_crs(sf::st_crs(polygon)) |>
    suppressMessages() |>
    suppressWarnings()
  
  #spatial join
  tiles_remote <- sf::st_join(
    x = polygon,
    y = dem_tiles
  ) |> 
    dplyr::mutate(
      tile = paste0(
        bucket_name,
        "/",
        get(column_name),
        "/",
        get(column_name),
        ".tif")
    ) |> 
    dplyr::pull(tile) |> 
    unique() |> 
    suppressMessages() |> 
    suppressWarnings()
  
  #download tiles
  tiles_local <- lapply(
    X = tiles_remote,
    FUN = function(x){
      
      local_tile <- paste0(folder,"/", basename(x))
      
      if(!file.exists(local_tile)){
        
        system(
          command = paste(
            "aws s3 cp --no-sign-request", 
            x, 
            local_tile
            ),
          wait = sequential_download, 
          ignore.stderr = quiet,
          ignore.stdout = quiet
        )
        
      }
      
      local_tile
      
    }
  ) |> 
    unlist()
  
  #waits untill all download jobs are done
  seconds <- 0
  while(all(file.exists(tiles_local)) == FALSE){
    Sys.sleep(5)
    seconds <- seconds + 5
    if(seconds > length(tiles_local) * 60){
      break
    }
  }
  
  #to vrt
  dem <- terra::vrt(
    x = tiles_local,
    filename = paste0(folder, "/dem.vrt"),
    return_filename = TRUE,
    overwrite = TRUE
  )
  
  if(output == "raster"){
    
    dem <- terra::rast(dem)
    dem[dem == 0] <- NA
  }
  
  dem
  
}
