#' Normalize_country_name
#'
#' Countries names normalization (find the correct)
#'
#' @param posnames Character vector of countries names to normalization.
#' @param dif_acc Float accuracy parametr of string matching. Must be from 0.0 to 1.0
#' @return Character vector of normalized names. Contains common names if normalizing was successful and "None" if not or unit vector "Invalid arguments" if types of arguments aren`t correct (for example, zero length names in argument posnames or incorrect type of dif_acc).
#' @examples
#' normalize_country_name("Russia")
#' vect <- c("ru", "en", "usa") # posnames
#' normalize_country_name(vect)
#' normalize_country_name("United States", 0.3)
normalize_country_name = function(posnames, dif_acc=0.2) {
# Игнорировать предупреждения во время работы
  options(warn=-1)

# Проверяем правильность параметров, инициализируем ответ значениями "None" (не найдено), загружаем б/д
  if (typeof(dif_acc) != "double" | length(dif_acc) == 0 | dif_acc <= 0 | dif_acc >= 1 | length(posnames) == 0 |
      typeof(posnames) != "character") return("Invalid arguments")
  answers <- rep("None", length(posnames))
  load(system.file("data", "countries_db.RData", package = "countriesLibR"))

# Приводим входные значения к удобному виду и проверяем их правильность после преобразований
  posnames <- enc2utf8(posnames)
  posnames <- tolower(posnames)
  punct <- '[]\\?!\"#$%123456789&(){}+*/:;,._|~\\[<=>@\\^-]'
  posnames <- str_replace_all(posnames, punct, " ")
  posnames <- str_replace_all(posnames, "\\s+", " ")
  posnames <- str_trim(posnames, side = "both")
  for (i in 1:length(posnames)) {
    if (length(posnames[i]) == 0) return("Invalid arguments")
    else if (posnames[i] == "") return("Invalid arguments")
  }

# Сначала ищем совпадение всей строки и значения с приоритетом "1"
# Проверка на длину - чтобы исключить варианты, когда совпало только начало или другая часть строки
# amatch() возвращает вектор индексов лучших совпадений
  posnames_tmp <- amatch(posnames, countries_db$key, method='jw', maxDist=dif_acc, nomatch=1)
  answers <- ifelse(countries_db[posnames_tmp, 3]=="1" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames)) <= 1,
  as.character(countries_db[posnames_tmp, 2]), answers)
# Ищем совпадение всей строки и значения с приоритетом "2"
  answers <- ifelse(countries_db[posnames_tmp, 3]=="2" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames)) <= 1
  & answers=="None", as.character(countries_db[posnames_tmp, 2]),answers)

# Ищем совпадение всей строки без пробелов и значения с приоритетом "1"
  posnames_new <- str_replace_all(posnames, " ", "")
  posnames_tmp <- amatch(posnames_new, countries_db$key, method='jw', maxDist=dif_acc, nomatch=1)
  answers <- ifelse(countries_db[posnames_tmp, 3]=="1" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames_new)) <= 1
  & answers=="None", as.character(countries_db[posnames_tmp, 2]), answers)
# Ищем совпадение всей строки без пробелов и значения с приоритетом "2"
  answers <- ifelse(countries_db[posnames_tmp, 3]=="2" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames_new)) <= 1
  & answers=="None", as.character(countries_db[posnames_tmp, 2]), answers)

# Делим входные строки на слова, разделитель - пробел
  posnames_new = strsplit(posnames, ' ')
  for (i in 1:length(posnames_new)) {
    posnames_tmp <- amatch(posnames_new[[i]], countries_db$key, method='jw', maxDist=dif_acc, nomatch=1)
# Переменная-флаг, чтобы завершить итерацию, если в одном из циклов нашлось подходящее значение
    cycle_flag <- TRUE
# Ищем равное по количеству букв совпадение части строки и значения с приоритетом "1"
    for (j in 1:length(posnames_tmp)) {
      if (countries_db[posnames_tmp[j], 3]=="1" & nchar(as.character(countries_db[posnames_tmp[j], 1])) ==
          nchar(as.character(posnames_new[[i]][j])) & answers[i] == "None") {
        answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
        cycle_flag <- FALSE
        break
      }
    }
  if (cycle_flag == FALSE) next
# Ищем неравное по количеству букв совпадение части строки и значения с приоритетом "1"
    for (j in 1:length(posnames_tmp)) {
       if (countries_db[posnames_tmp[j], 3]=="1" & answers[i] == "None") {
         answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
         cycle_flag <- FALSE
         break
       }
     }
        if (cycle_flag == FALSE) next
# Ищем равное по количеству букв совпадение части строки и значения с приоритетом "2"
    for (j in 1:length(posnames_tmp)) {
       if (countries_db[posnames_tmp[j], 3]=="2" & nchar(as.character(countries_db[posnames_tmp[j], 1])) ==
           nchar(as.character(posnames_new[[i]][j])) & answers[i] == "None") {
         answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
         cycle_flag <- FALSE
         break
       }
    }
    if (cycle_flag == FALSE) next
# Ищем неравное по количеству букв совпадение части строки и значения с приоритетом "2"
    for (j in 1:length(posnames_tmp)) {
       if (countries_db[posnames_tmp[j], 3]=="1" & answers[i] == "None") {
         answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
         break
       }
    }
  }

  return(answers)
}


#' Match_country_name
#'
#' Add countries names to database
#'
#' @param posnames Character vector of possible countries names.
#' @param realnames Character vector of official(common) countries names.
#' @param priorities Character vector of priorities. Takes values "1" or "2". Priorities should have same length with posnames, otherwise will be initialized priorities vector with length of posnames and value "2".
#' @return Unit character vector "Success" if matching was correct, or unit vector "Invalid arguments" if types of arguments aren`t correct (for example, zero length names in argument posnames or diffrent length of posnames and realnames).
#' @examples
#' match_country_name("Rassiya", "Russia")
#' vect_1 <- c("ru", "en", "usa") # posnames
#' vetc_2 <- c("Russia", "United Kingdom", "United States") #realnames
#' match_country_name(vect_1, vect_2)
#' vect_3 <- c("1", "2", "1") # priorities
#' match_country_name(vect_1, vect_2, vect_3)
match_country_name = function(posnames, realnames, priorities="2") {
# Игнорировать предупреждения во время работы
  options(warn=-1)

# Загружаем б/д
  load(system.file("data", "countries_db.RData", package = "countriesLibR"))

# Сравниваем длины векторов ключей, значений и приоритетов, инициализируем вектор приоритетов при необходимости
  if (length(posnames) != length(realnames)) return("Invalid arguments")
  for (i in 1:length(priorities)) {
    if (length(priorities[i]) == 0) return("Invalid arguments")
    else if (priorities[i] != "1" & priorities[i] != "2") return("Invalid arguments")
  }
  if (length(priorities) != length(posnames)) priorities <- rep("2", length(posnames))

# На основе входных данных создаем таблицу данных и соединяем ее с загруженной.
# Ключи приводятся к удобному виду
  posnames <- enc2utf8(posnames)
  posnames <- tolower(posnames)
  punct <- '[]\\?!\"#$%123456789&(){}+*/:;,._|~\\[<=>@\\^-]'
  posnames <- str_replace_all(posnames, punct, "")
  posnames <- str_replace_all(posnames, "\\s+", " ")
  posnames <- str_trim(posnames, side = "both")
  for (i in 1:length(posnames)) {
    if (length(posnames[i]) == 0) return("Invalid arguments")
    else if (posnames[i] == "") return("Invalid arguments")
  }
  new_df <- data.frame(
    key = posnames,
    value = realnames,
    priority = priorities
  )
# Если ключ уже есть в б/д, то он удаляется из новой таблицы данных
  for (i in 1:length(posnames)) {
    if (length(which(countries_db$key == posnames[i])) != 0) {
      new_df <- new_df[-which(new_df == posnames[i]), ]
    }
  }
  countries_db <- rbind(countries_db, new_df)
  save(countries_db, file = system.file("data", "countries_db.RData", package = "countriesLibR"))

  return("Success")
}


#' Del_country_name
#'
#' Delete countries names from database
#'
#' @param posnames Character vector of possible countries names.
#' @return Unit character vector "Success" if deleting was correct, or unit vector "Invalid arguments" if type of argument isn`t correct (for example, zero length names in argument posnames).
#' @examples
#' del_country_name("Russia")
#' vect <- c("ru", "en", "usa") # posnames
#' del_country_name(vect)
del_country_name = function(posnames) {
# Игнорировать предупреждения во время работы
  options(warn=-1)

# Загружаем б/д
  load(system.file("data", "countries_db.RData", package = "countriesLibR"))

# Находим номер строки с введенным ключом и удаляем
  posnames <- enc2utf8(posnames)
  posnames <- tolower(posnames)
  for (i in 1:length(posnames)) {
    if (length(which(countries_db$key == posnames[i])) != 0) {
    countries_db <- countries_db[-which(countries_db$key == posnames[i]), ]
    }
  }
  save(countries_db, file = system.file("data", "countries_db.RData", package = "countriesLibR"))

  return("Success")
}
