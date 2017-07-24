## Импорт: stringr, stringdist

normalize_country_name = function(posnames, dict)
{
##dict <- read.csv(file="csvfile.csv", encoding="UTF-8")
## Приводим к нижнему регистру и убираем пунктуацию
posnames <- enc2utf8(posnames)
posnames <- tolower(posnames)
posnames <- str_replace_all(posnames, "[[:punct:]]", " ")
posnames <- str_replace_all(posnames, "\\s+", " ")
posnames <- str_trim(posnames, side = "both")
## Находим ближайший элемент
posnames <- amatch(posnames, dict$key)

}