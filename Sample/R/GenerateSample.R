#' @title Hello World Example
#'
#' @description It's just an example to show how to develop a R package.
#' @param name a string that will appear before "Hello, world!"
#' @export
#' @seealso \code{\link[base]{paste}}
#' @return NULL
#' @examples \dontrun{
#' hello("Linda")
#' [1] "Linda Hello, world!"
#' hello("Adam")
#' [1] "Adam Hello, world!"
#'}
hellofunction <- function(name) {
  print(paste(name,"Hello, world!"))
}
