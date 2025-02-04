% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/database_access.r
\name{list_ecotox_fields}
\alias{list_ecotox_fields}
\title{List the field names that are available from the ECOTOX database}
\usage{
list_ecotox_fields(which = c("default", "full", "all"), include_table = TRUE)
}
\arguments{
\item{which}{A \code{character} string that specifies which fields to return. Can be any of:
'\code{default}': returns default output field names; '\code{all}': returns all fields; or
'\code{full}': returns all except fields from table 'dose_response_details'.}

\item{include_table}{A \code{logical} value indicating whether the table name should be included
as prefix. Default is \code{TRUE}.}
}
\value{
Returns a \code{vector} of type \code{character} containing the field names from the ECOTOX database.
}
\description{
List the field names (table headers) that are available from the ECOTOX database
}
\details{
This can be useful when specifying a \code{\link{search_ecotox}}, to identify which fields
are available from the database, for searching and output.
}
\examples{
## Fields that are included in search results by default:
list_ecotox_fields("default")

## All fields that are available from the ECOTOX database:
list_ecotox_fields("all")

## All except fields from the table 'dose_response_details'
## that are available from the ECOTOX database:
list_ecotox_fields("all")
}
\author{
Pepijn de Vries
}
