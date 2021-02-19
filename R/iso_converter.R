#' iso_converter
#'
#' This function converts English countries names to their respective ISO codes, using \code{\link{ifs_countries}}.
#'
#' @param names a vector of strings
#'
#' @examples
#' iso_converter(names = c("Brazil","Canada"))
#' @export

iso_converter <- function(names){

  if( is.vector(names, mode ="character") ){
    if( all(names %in% surexr::ifs_countries$Name) ){
      names <- surexr::ifs_countries$Code[surexr::ifs_countries$Name %in% names]
      return(names[order(names)])
    } else{
      wrong_name <- names[which(!names%in% surexr::ifs_countries$Name)]
      print(paste0("Error: ",wrong_name," is not a valid name. Have you checked ifs_countries?"))
    }
  } else {
    print("Error: names is not a vector of strings")
  }

}
