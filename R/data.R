#' Possible and common names of countries.
#'
#' A dataset containing the possible names of countries (official, common, shortened names, 2 and 3 letters indices, translations, capitals, regions and another), real names of countries (common) and their priorities.
#' The priority means what is the possible name: variables: official, common, shortened names, 2 and 3 letters indices and translations if priority is "1" or something another if priority is "2".
#'
#' @format A data frame with over 10700 rows and 3 columns:
#' \describe{
#'   \item{key}{possible name, a character unit vector}
#'   \item{value}{real name , a character unit vector}
#'   \item{priority}{priority, a character}
#' }
#' @source This database was build from \url{https://github.com/mledoze/countries} and \url{https://github.com/x88/i18nGeoNamesDB}.
"countries_db"
