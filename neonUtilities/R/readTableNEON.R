##############################################################################################
#' @title Read a NEON data table with correct data types for each variable

#' @author
#' Claire Lunch \email{clunch@battelleecology.org}

#' @description
#' Load a table into R, assigning classes to each column based on data types in variables file; or convert a table already loaded
#'
#' @param dataFile A data frame containing a NEON data table, or the filepath to a data table to load
#' @param varFile A data frame containing the corresponding NEON variables file, or the filepath to the variables file
#' @param useFasttime Should the fasttime package be used to read date-time variables? Defaults to false.
#' @return A data frame of a NEON data table, with column classes assigned by data type

#' @references
#' License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007
#' 
#' @export

# Changelog and author contributions / copyrights
#   Claire Lunch (2019-11-08)
##############################################################################################

readTableNEON <- function(dataFile, varFile, useFasttime=FALSE){
  
  # check for fasttime package, if used
  if(useFasttime & !requireNamespace("fasttime", quietly=T)) {
    stop("Parameter useFasttime is TRUE but fasttime package is not installed. Install and re-try.")
  }
  
  # read in variables file
  if(inherits(varFile, 'character')) {
    v <- utils::read.csv(varFile, header = T, stringsAsFactors = F,
                         na.strings=c('NA',''), encoding='UTF-8')
  } else {
    v <- try(as.data.frame(varFile), silent=T)
    if(inherits(v, 'try-error')) {
      stop('varFile must be either a NEON variables table or a file path to a NEON variables table.\n')
    }
  }
  
  # check this is a valid variables file
  if(any(c('category','system','stat') %in% names(v))) {
    stop('varFile appears to match DP4.00200.001. Use the stackEddy() function to work with surface-atmosphere exchange data.')
  } else {
    if(any(!c('table','fieldName','dataType') %in% names(v))) {
      stop('varFile is not a variables file, or is missing critical values.\n')
    }
  }

  # make a new colClass column defaulting to numeric
  # modify to character for strings and urls
  v$colClass <- rep("numeric", nrow(v))
  v$colClass[which(v$dataType %in% c("string","uri"))] <- "character"
  v$colClass[which(v$dataType %in% c("date","dateTime"))] <- 'date'

  v <- v[, c("table", "fieldName", "colClass")]
  
  # read in data file
  if(inherits(dataFile, 'character')) {
    d <- suppressWarnings(utils::read.csv(dataFile, header=T, stringsAsFactors=F,
                         colClasses=c(horizontalPosition='character', verticalPosition='character'),
                         na.strings=c('NA',''), encoding='UTF-8'))
  } else {
    d <- try(as.data.frame(dataFile, stringsAsFactors=F), silent=T)
    if(inherits(d, 'try-error')) {
      stop('dataFile must be either a NEON data table or a file path to a NEON data table.\n')
    }
  }
  
  # check that most fields have a corresponding value in variables
  m <- length(which(!names(d) %in% v$fieldName))
  if(m==length(names(d))) {
    stop('Variables file does not match data file.\n')
  }
  if(m>4) {
    message(paste(m, " fieldNames are present in data files but not in variables file. Unknown fields are read as character strings.\n", sep=""))
  }
  
  # fieldNames each have a unique dataType - don't need to match table
  for(i in names(d)) {
    if(!i %in% v$fieldName) {
      d[,i] <- as.character(d[,i])
    } else {
      type <- v$colClass[which(v$fieldName==i)][1]
      if(type=='numeric') {
        d[,i] <- as.numeric(d[,i])
      }
      if(type=='character') {
        d[,i] <- as.character(d[,i])
      }
      if(type=='date') {
        d[,i] <- dateConvert(d[,i], useFasttime=useFasttime)
      }
    }
  }

  return(d)
}
