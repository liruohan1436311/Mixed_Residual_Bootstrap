#' @title Generate Mixed Residual Bootstrap Samples
#'
#' @description It is a very useful function to generate Mixed Residual Bootstrap Samples.
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
generate <- function(name) {
  print(paste(name,"Hello, world!"))
}
