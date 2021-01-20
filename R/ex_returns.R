#' ex_returns
#'
#' \code{ex_returns} calculates excess returns
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
#'

load("C:\\Monografia\\cod\\Calculo dos excessos de retorno\\base_final.Rdata")

data <- dplyr::filter(base_final, base_final$iso %in% c("AU","US"))

ex_returns <- function(data){

  colunas <- c("iso","month","intrate","exrate","cpi")

  if(!colnames(data) %in% colunas){
    print("Error: wrong dataframe format. Check documentation.")
  } else {

    data$exrate_var <- data$exrate/lag(data$exrate)
    data$cpi_var <- data$cpi/lag(data$cpi)
    data$ex_returns <- (((1+data$intrate/100)*data$exrate_var)-(1+data$intrate[data$iso=="US"]/100))/data$cpi_var

  }
}

data <- filter(data, data$iso=="AU")
mean(data$ex_returns,na.rm = T)
