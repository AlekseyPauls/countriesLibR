normalize_country_name = function(posnames) {
# To ignore the warnings during usage
    options(warn=-1)

# �������������� ����� (�� ��������� - "None" (�� �������)) � ��������� �/�
    answers <- rep("None", length(posnames))
    load(system.file("data", "countries_db.RData", package = "countries_lib"))

# �������� � ������� ��������, ������� ���������� � ������ �������
    posnames <- enc2utf8(posnames)
    posnames <- tolower(posnames)
    posnames <- str_replace_all(posnames, "[[:punct:]]", " ")
    posnames <- str_replace_all(posnames, "\\s+", " ")
    posnames <- str_trim(posnames, side = "both")

# ������� ��� ���� ������ ���������� ���� � ����������� "1"
# �������� �� ����� - ����� ��������� ��������, ����� ������� ������ ������ ��� ������ ����� ������
# amatch() ���������� ������� ������� ���������� � ������� ������, ���� None, ���� ���������� ���
    posnames_tmp <- amatch(posnames, countries_db$key, maxDist=5,nomatch=1)
    answers <- ifelse(countries_db[posnames_tmp, 3]=="1" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames)) <= 1, 
    as.character(countries_db[posnames_tmp, 2]),answers)
# ������� ��� ���� ������ ���������� ���� � ����������� "2"
    answers <- ifelse(countries_db[posnames_tmp, 3]=="2" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames)) <= 1 
    & answers=="None", as.character(countries_db[posnames_tmp, 2]),answers)

# ������� ��� ���� ������ ��� �������� ���������� ���� � ����������� "1"
    posnames_new <- str_replace_all(posnames, " ", "")
    posnames_tmp <- amatch(posnames_new, countries_db$key, maxDist=5,nomatch=1)
    answers <- ifelse(countries_db[posnames_tmp, 3]=="1" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames_new)) <= 1 
    & answers=="None", as.character(countries_db[posnames_tmp, 2]),answers)
# ������� ��� ���� ������ ��� �������� ���������� ���� � ����������� "2"
    answers <- ifelse(countries_db[posnames_tmp, 3]=="2" & abs(nchar(as.character(countries_db[posnames_tmp, 1]))-nchar(posnames_new)) <= 1 
    & answers=="None", as.character(countries_db[posnames_tmp, 2]),answers)

# ����� ������� ������ �� �����, ����������� - ������. �������� ������ ���������� ��������
    posnames_new = strsplit(posnames, ' ')
    for (i in 1:length(posnames_new)) {
        posnames_tmp <- amatch(posnames_new[[i]], countries_db$key, maxDist=5,nomatch=1)
# ����������-����. ���� � �����-�� �� ������ ������� ����������, �� ��������� �� ��������� ��������
        cycle_flag <- TRUE
# ���� ������ �� ���������� ���� ���������� ����� ������ � �������� � ����������� '1'
        for (j in 1:length(posnames_tmp)) {
            if (countries_db[posnames_tmp[j], 3]=="1" & nchar(as.character(countries_db[posnames_tmp[j], 1])) == 
            nchar(as.character(posnames_new[[i]][j])) & answers[i] == "None") {
            answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
            cycle_flag <- FALSE 
            break
            }
        }
        if (cycle_flag == FALSE) next
# ���� �������� �� ���������� ���� ���������� ����� ������ � �������� � ����������� '1'
        for (j in 1:length(posnames_tmp)) {
            if (countries_db[posnames_tmp[j], 3]=="1" & answers[i] == "None") {
            answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
            cycle_flag <- FALSE 
            break
            }
        }
        if (cycle_flag == FALSE) next
# ���� ������ �� ���������� ���� ���������� ����� ������ � �������� � ����������� '2'
        for (j in 1:length(posnames_tmp)) {
            if (countries_db[posnames_tmp[j], 3]=="2" & nchar(as.character(countries_db[posnames_tmp[j], 1])) == 
            nchar(as.character(posnames_new[[i]][j])) & answers[i] == "None") {
            answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
            cycle_flag <- FALSE 
            break
            }
        }
        if (cycle_flag == FALSE) next
# ���� �������� �� ���������� ���� ���������� ����� ������ � �������� � ����������� '2'
        for (j in 1:length(posnames_tmp)) {
            if (countries_db[posnames_tmp[j], 3]=="1" & answers[i] == "None") {
            answers[i] <- as.character(countries_db[posnames_tmp[j], 2])
            break
            }
        }
    }

    return(answers)
}


match_country_name = function(posnames, realnames, priorities="2") {
# To ignore the warnings during usage
    options(warn=-1)

# ��������� �/�
    path <- system.file("data", "countries_db.RData", package = "countries_lib")
    load(path)


# ��������� ����� ������� ��������
    if (length(posnames) != length(realnames) | length(priorities) > length(posnames)) return("Invalid arguments")
    if (length(priorities) < length(posnames)) priorities <- rep("2", length(posnames))

# ������� ������� ������ ��� ����� �������� � ��������� �� � ������������
    posnames <- enc2utf8(posnames)
    posnames <- tolower(posnames)
    new_df <- data.frame(
        key = posnames,
        value = realnames,
        priority = priorities
    )
    countries_db <- rbind(countries_db, new_df)
    save(countries_db, file = path)

    return("Success")
}