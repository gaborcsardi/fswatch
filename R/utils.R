
random_id <- function() {
  paste(
    sample(c(0:9, letters[1:6]), 16, replace = TRUE),
    collapse = ""
  )
}
