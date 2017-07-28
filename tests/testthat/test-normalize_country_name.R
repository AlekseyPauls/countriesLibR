context("normalize_country_name")

test_that("normalize_country_name of simple name", {
  input <- c("Russia", "America", "Китай")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name and punctuation sensitivity", {
  input <- c("Russia!!!#^", "$$$A$m$e$r$i$c$a$$$", "К%^*итай^)))(%^")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name of upper register", {
  input <- c("RUSSIA", "AMERICA", "КИТАЙ")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name of low register", {
  input <- c("russia", "america", "китай")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name and missed letter", {
  input <- c("Russi", "Aerica", "итай")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name and excess letter", {
  input <- c("Russiaa", "Ammerica", "Киfтай")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name and another letter", {
  input <- c("Rassia", "Amurica", "Киtай")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name of simple two words name", {
  input <- c("United States")
  output <- c("United States")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name and excess word name", {
  input <- c("The Russia", "America nerulit", "Китай 2003.04.13")
  Encoding(input) <- "UTF-8"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name of american_paris_like_construction", {
  input <- c("Moskow, Russia", "Paris, USA")
  output <- c("Russia", "United States")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name and standard accuracy result", {
  input <- c("azazaza", "fgfg1341341dfadfadf", "IAmTheHackerman")
  output <- c("None", "None", "None")
  expect_equal(normalize_country_name(input), output)
})

test_that("normalize_country_name and correct accuracy", {
  input <- c("Russia", "America", "Китай")
  Encoding(input) <- "UTF-8"
  input_dif_acc <- 0.4
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input, input_dif_acc), output)
})

test_that("normalize_country_name and incorrect accuracy type", {
  input <- c("Russia", "America", "Китай")
  Encoding(input) <- "UTF-8"
  input_dif_acc <- "1"
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input, input_dif_acc), "Invalid arguments")
})

test_that("normalize_country_name and incorrect accuracy value", {
  input <- c("Russia", "America", "Китай")
  Encoding(input) <- "UTF-8"
  input_dif_acc <- -1
  output <- c("Russia", "United States", "China")
  expect_equal(normalize_country_name(input, input_dif_acc), "Invalid arguments")
})

test_that("normalize_country_name and incorrect posnames", {
  input <- ""
  expect_equal(normalize_country_name(input), "Invalid arguments")
  input <- c("ru", ":)")
  expect_equal(normalize_country_name(input), "Invalid arguments")
})
