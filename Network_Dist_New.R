## Clear memory
rm(list = ls())
library(osrm)

## Set Working Directory and load data
setwd("D:/New Variable/R code")
charging <- read.csv("Charging_Staions_Lat_Long.csv", header = TRUE)
busstops <- read.csv("Bus_Stops_Telangana.csv", header = TRUE)

## STEP 0: Check your actual column names first
print(colnames(charging))
print(colnames(busstops))

## ===================================================================
## IMPORTANT: Replace the column names below (origin_lon, origin_lat,
## destination_lon, destination_lat) with whatever colnames() printed
## above for YOUR files. These are just placeholders.
## ===================================================================

src <- data.frame(
  lon = as.numeric(as.character(charging$origin_lon)),
  lat = as.numeric(as.character(charging$origin_lat))
)

dst <- data.frame(
  lon = as.numeric(as.character(busstops$destination_lon)),
  lat = as.numeric(as.character(busstops$destination_lat))
)

## STEP 1: Diagnostics — check BEFORE calling osrmTable
cat("---- src ----\n")
print(str(src))
print(head(src))
cat("Rows in src:", nrow(src), "\n")
cat("NA count in src$lon:", sum(is.na(src$lon)), "\n")
cat("NA count in src$lat:", sum(is.na(src$lat)), "\n\n")

cat("---- dst ----\n")
print(str(dst))
print(head(dst))
cat("Rows in dst:", nrow(dst), "\n")
cat("NA count in dst$lon:", sum(is.na(dst$lon)), "\n")
cat("NA count in dst$lat:", sum(is.na(dst$lat)), "\n\n")

## STEP 2: Remove any rows with missing coordinates (osrmTable cannot handle NAs)
src <- src[complete.cases(src), ]
dst <- dst[complete.cases(dst), ]

cat("After removing NAs -> src rows:", nrow(src), " dst rows:", nrow(dst), "\n")

## STEP 3: Stop here with a clear message if something is still wrong
if (nrow(src) == 0) stop("src has 0 valid rows — check your origin_lon/origin_lat column names above.")
if (nrow(dst) == 0) stop("dst has 0 valid rows — check your destination_lon/destination_lat column names above.")



## STEP 4: Network distance matrix in small blocks
n_src <- nrow(src)
n_dst <- nrow(dst)

mat <- matrix(
  NA,
  nrow = n_src,
  ncol = n_dst
)

src_batch_size <- 20
dst_batch_size <- 20

for (s_start in seq(1, n_src, by = src_batch_size)) {
  
  s_end <- min(s_start + src_batch_size - 1, n_src)
  
  for (d_start in seq(1, n_dst, by = dst_batch_size)) {
    
    d_end <- min(d_start + dst_batch_size - 1, n_dst)
    
    cat(
      "Charging:", s_start, "-", s_end,
      "| Bus stops:", d_start, "-", d_end, "\n"
    )
    
    src_batch <- src[s_start:s_end, ]
    dst_batch <- dst[d_start:d_end, ]
    
    result <- osrmTable(
      src = src_batch,
      dst = dst_batch,
      measure = "distance"
    )
    
    mat[
      s_start:s_end,
      d_start:d_end
    ] <- result$distances
    
    Sys.sleep(2)
  }
}
## Check final matrix
dim(mat)
database <- data.frame(
  station_row         = src$id,
  origin_lon          = src$lon,
  origin_lat          = src$lat,
  destination_lon     = dst$lon[nearest_idx],
  destination_lat     = dst$lat[nearest_idx],
  distance_km         = nearest_dist
)

## STEP 6: Save output
write.csv(database, "Distances.csv", row.names = FALSE)
head(database)