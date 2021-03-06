% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pin_extractors.R
\name{pin_extractors}
\alias{pin_extractors}
\alias{pin_extract}
\alias{pin_dob}
\alias{pin_century}
\alias{pin_sex}
\title{Extract data from PIN}
\usage{
pin_extract(data, pin, into = c("dob", "sex"), remove = FALSE, ...)

pin_dob(x)

pin_century(x)

pin_sex(x, factor = TRUE, language = c("english", "finnish"))
}
\arguments{
\item{data}{A data frame with a PIN column.}

\item{pin}{The name of the column cotaining PINs. Can be a bare
name or a string. Uses `tidyselect` semantics to pick the column
from the data.}

\item{into}{A character vector of length 2. Gives the names of the
new columns that date of birth and sex are extracted into.}

\item{remove}{Logical. Should the original PIN column be removed?}

\item{...}{Additional arguments passed to `pin_sex`.}

\item{x}{Character vector of PINs.}

\item{factor}{Logical. Should the return value be a factor?}

\item{language}{Character scalar. Language to use for factor labels if
\code{factor = TRUE}. Currently either \code{english} or \code{finnish}.}
}
\description{
Extract data from PIN
}
\section{Functions}{
\itemize{
\item \code{pin_extract}: Extract date of birth and sex into new
columns in a supplied data frame.

\item \code{pin_dob}: Extract date of birth from PIN

\item \code{pin_century}: Extract century of birth from PIN

\item \code{pin_sex}: Extract sex from PIN
}}

