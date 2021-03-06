% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/byFileAOP.R
\name{byFileAOP}
\alias{byFileAOP}
\title{Serially download all AOP files for a given site, year, and product}
\usage{
byFileAOP(dpID, site, year, check.size = TRUE, savepath = NA)
}
\arguments{
\item{dpID}{The identifier of the NEON data product to pull, in the form DPL.PRNUM.REV, e.g. DP1.10023.001}

\item{site}{The four-letter code of a single NEON site, e.g. 'CLBJ'.}

\item{year}{The four-digit year to search for data. Defaults to 2017.}

\item{check.size}{T or F, should the user approve the total file size before downloading? Defaults to T. When working in batch mode, or other non-interactive workflow, use check.size=F.}

\item{savepath}{The file path to download to. Defaults to NA, in which case the working directory is used.}
}
\value{
A folder in the working directory, containing all files meeting query criteria.
}
\description{
Query the API for AOP data by site, year, and product, and download all files found, preserving original
folder structure. Downloads serially to avoid overload; may take a very long time.
}
\examples{
\dontrun{
# To download 2017 vegetation index data from San Joaquin Experimental Range:
byFileAOP(dpID="DP3.30026.001", site="SJER", year="2017")
}
}
\references{
License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007
}
\author{
Claire Lunch \email{clunch@battelleecology.org}
Christine Laney \email{claney@battelleecology.org}
}
