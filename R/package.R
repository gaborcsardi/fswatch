
watchers <- new.env()

#' Watch a File or Directory for Changes
#'
#' Get notification is a file or any file in a directory changes. It uses
#' the fswatch tool (see \url{https://github.com/emcrisostomo/fswatch})
#' and works on major platforms.
#'
#' @section Additional methods:
#'
#' \code{fswatch$list()} lists all watchers.
#'
#' \code{fswatch$cancel(id} cancels a watcher.
#'
#' @usage
#' fswatch(path, callback, check_interval = 500)
#'
#' ## id <- fswatch(path, callback, check_interval = 500)
#' ## fswatch$cancel(id)
#' ## fswatch$list()
#'
#' @param path Path to watch. It can be a directory or a file.
#'   Directories are watched recursively.
#' @param callback Callback function to call when \code{path} is
#'   updated, i.e. the modification time of the file, or a file in the
#'   directory changed. The function will be called with one argument:
#'   a character vector of the changed files and directories.
#' @param check_interval How long to wait between checks for changes,
#'   in milliseconds. Defaults to half a second.
#' @return The ID of the watcher. This can be used to cancel it later.
#'
#' @export
#' @importFrom after after
#' @examples
#' id <- fswatch(tempdir(), callback = function(f) print(f))
#' tmp <- tempfile()
#' tmp
#' cat("hello", file = tmp)
#' Sys.sleep(1)
#' file.remove(tmp)
#' Sys.sleep(1)
#'
#' fswatch$list()
#' fswatch$cancel(id)
#' fswatch$list()

fswatch <- function(path, callback, check_interval = 500) {

  id <- random_id()
  w <- after(
    check_interval,
    make_watcher(id, path),
    args = list(id, path, callback),
    redo = Inf
  )

  assign(id, w, envir = watchers)

  invisible(id)
}

class(fswatch) <- "fswatch_package"

#' @export

`$.fswatch_package` <- function(x, name) {
  if (name %in% names(fswatch_functions)) {
    fswatch_functions[[name]]
  } else {
    stop("Unknown 'fswatch' function")
  }
}

#' @export

names.fswatch_package <- function(x) {
  names(fswatch_functions)
}

fswatch_cancel <- function(id) {
  after$cancel(get(id, envir = watchers))
  rm(list = id, envir = watchers)
}

fswatch_list <- function() {
  ls(watchers)
}

fswatch_functions <- list(
  "cancel" = fswatch_cancel,
  "list" = fswatch_list
)

make_watcher <- function(id, path) {
  setup_fswatch(path, id)
  function(id, path, callback) {
    poll_watcher(id, path, callback)
  }
}

output_file <- function(id) {
  file.path(tempdir(), id)
}

setup_fswatch <- function(path, id) {
  cmd <- paste(
    "fswatch -1 -l 0.001 -L ",
    shQuote(path),
    ">", shQuote(output_file(id))
  )
  system(cmd, wait = FALSE)
}

poll_watcher <- function(id, path, callback) {
  of <- output_file(id)
  if (file.size(of) != 0) {
    callback(readLines(of))
    file.remove(of)
    setup_fswatch(path, id)
  }
}
