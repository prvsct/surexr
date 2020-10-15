#' ifs_data
#'
#' \code{ifs_data} downloads data from IFS.
#' A simplification of \code{\link[imfr]{imf_data}}, which sets \code{database_id} to \code{"IFS"}, \code{times} to \code{3} and both \code{return_raw} and \code{print_url} to \code{FALSE}.
#'
#' @param indicator A character, the IFS database indicator as in \code{ifs_indicators} dataframe.
#' @param country A character, the ISO code of the country as in \code{ifs_countries} dataframe.
#' @param start A number, the year for which you would like to start gathering the data.
#' @param end A number, the year for which you would like to start gathering the data.
#' @param freq A character, indicating the series frequency. With 'A' for annual, 'Q' for quarterly, and 'M' for monthly.
#'
#' Please see also \code{\link[imfr]{imf_data}} for a more throughout explanation.
#' @examples
#' ifs_data(indicator = "ENDE_XDC_USD_RATE", country = c("UK","BR"), start = 1999, end = 2020, freq = "M")
#' @export


ifs_data <- function(indicator,
                     country,
                     start,
                     end,
                     freq){
  imfr::imf_data(database_id = "IFS",
                 indicator = indicator,
                 country = country,
                 start = start,
                 end = end,
                 freq = freq,
                 return_raw = F,
                 print_url = F,
                 times = 3)
}

