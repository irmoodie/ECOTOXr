% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrappers.r
\name{search_ecotox}
\alias{search_ecotox}
\alias{search_query_ecotox}
\title{Search and retrieve toxicity records from the database}
\usage{
search_ecotox(
  search,
  output_fields = list_ecotox_fields("default"),
  group_by_results = TRUE,
  ...
)

search_query_ecotox(
  search,
  output_fields = list_ecotox_fields("default"),
  group_by_results = TRUE
)
}
\arguments{
\item{search}{A named \code{list} containing the search terms. The names of the elements should refer to
the field (i.e. table header) in which the terms are searched. Use \code{\link{list_ecotox_fields}()} to
obtain a list of available field names.

Each element in that list should contain another list with at least one element named 'terms'. This should
contain a \code{vector} of \code{character} strings with search terms. Optionally, a second element
named 'method' can be provided which should be set to either '\code{contain}' (default, when missing) or
'\code{exact}'. In the first case the query will match any record in the indicated field that contains
the search term. In case of '\code{exact}' it will only return exact matches. Note that searches are
not case sensitive, but are picky with special (accented) characters. While building the local database
(see \link{build_ecotox_sqlite}) such special characters may be treated differently on different
operating systems. For the sake of reproducibility, the user is advised to stick with non-accented
alpha-numeric characters.

Search terms for a specific field (table header) will be combined with 'or'. Meaning that any record that
matches any of the terms are returned. For instance when 'latin_name' 'Daphnia magna' and 'Skeletonema costatum'
are searched, results for both species are returned. Search terms across fields (table headers) are combined with
'and', which will narrow the search. For instance if 'chemical_name' 'benzene' is searched in combination
with 'latin_name' 'Daphnia magna', only tests where Daphnia magna are exposed to benzene are returned.

When this search behaviour described above is not desirable, the user can either adjust the query manually,
or use this function to perform several separate searches and combine the results afterwards.

Beware that some field names are ambiguous and occur in multiple tables (like `cas_number' and `code').
When searching such fields, the search result may not be as expected.}

\item{output_fields}{A \code{vector} of \code{character} strings indicating which field names (table headers)
should be included in the output. By default \code{\link{list_ecotox_fields}("default")} is used. Use
\code{\link{list_ecotox_fields}("all")} to list all available fields.}

\item{group_by_results}{Ecological test results are generally the most informative element in the ECOTOX
database. Therefore, this search function returns a table with unique results in each row.

However, some tables in the database (such as 'chemical_carriers' and 'dose_responses') have a one to many
relationship with test results. This means that multiple chemical carriers can be linked to a single test result,
similarly, multiple doses can also be linked to a single test result.

By default the search results are grouped by test results. As a result not all doses or chemical carriers may
be displayed in the output. Set the \code{group_by_results} parameter to \code{FALSE} in order to force SQLite
to output all data (all carriers and doses). But beware that test results may be duplicated in those cases.}

\item{...}{Arguments passed to \code{\link{dbConnectEcotox}}. You can use this when the database
is not located at the default path (\code{\link{get_ecotox_path}()}).}
}
\value{
In case of \code{search_query_ecotox}, a \code{character} string containing an SQL
query is returned. This query is built based on the provided search terms and options.

In case of \code{search_ecotox} a \code{data.frame} is returned based on the search query built with
\code{search_query_ecotox}. The \code{data.frame} is unmodified as returned by SQLite, meaning that all
fields are returned as \code{character}s (even where the field types are 'date' or 'numeric').

The results are tagged with: a time stamp; the package version used; and the
file path of the SQLite database used in the search (when applicable). These tags are added as attributes
to the output table or query.
}
\description{
Create (and execute) an SQL search query based on basic search terms and options. This allows you to search
the database, without having to understand SQL.
}
\details{
The ECOTOX database is stored locally as an SQLite file, which can be queried with SQL. These functions
allow you to automatically generate an SQL query and send it to the database, without having to understand
SQL. The function \code{search_query_ecotox} generates and returns the SQL query (which can be edited by
hand if desired). You can also directly call \code{search_ecotox}, this will first generate the query,
send it to the database and retrieve the result.


Although the generated query is not optimized for speed, it should be able to process most common searches
within an acceptable time. The time required for retrieving data from a search query depends on the complexity
of the query, the size of the query and the speed of your machine. Most queries should be completed within
seconds (or several minutes at most) on modern machines. If your search require optimisation for speed,
you could try reordering the search fields. You can also edit the query generated with \code{search_query_ecotox}
by hand and retrieve it with \code{\link[DBI]{dbGetQuery}}.

Note that this package is actively maintained and this function may be revised in future versions.
In order to create reproducible results the user must: always work with an official release from
CRAN and document the package and database version that are used to generate specific results (see also
\code{\link{cite_ecotox}()}).
}
\examples{
\dontrun{
## let's find the ids of all ecotox tests on species
## where latin names contain either of 2 specific genus names and
## where they were exposed to the chemical benzene
if (check_ecotox_availability()) {
  search <-
    list(
      latin_name    = list(
        terms          = c("Skeletonema", "Daphnia"),
        method         = "contains"
      ),
      chemical_name = list(
        terms          = "benzene",
        method         = "exact"
      )
    )
  ## numbers in result each represent a unique test id from the database
  result <- search_ecotox(search)
  query  <- search_query_ecotox(search)
  cat(query)
} else {
  print("Sorry, you need to use 'download_ecotox_data()' first in order for this to work.")
}
}
}
\author{
Pepijn de Vries
}
