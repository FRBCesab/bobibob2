% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download-gbif.R
\name{find_taxon}
\alias{find_taxon}
\title{Find the taxon key corresponding to the group of interest}
\usage{
find_taxon(name, rank)
}
\arguments{
\item{name}{The taxon name}

\item{rank}{The taxon rank}
}
\value{
A taxon_key object containing the single identifier of the taxon in Gbif
}
\description{
Find the taxon key corresponding to the group of interest
}
\examples{
\dontrun{
find_taxon ("laminaria digitata", "species")
}

}
