#' @title Generate Mixed Residual Bootstrap Samples
#'
#' @description It is a very useful function to generate Mixed Residual Bootstrap Samples.
#' @param X The design matrix with dimension n by p, where n represents the number of observations and p represents the number of parameters.
#' @param y The n observations of the dependent variable y.
#' @param nboot Specify the number of Mixed Residual Bootstrap samples that you want to generate. Noted that the input should be a positive integar.
#' @export
#' @seealso \code{\link[base]{paste}}
#' @return returnlist
#' @examples \dontrun{
#' hello("Linda")
#' [1] "Linda Hello, world!"
#' hello("Adam")
#' [1] "Adam Hello, world!"
#'}
generate <- function(X,y,nboot) {
  n <- nrow(X)
  bootx <- matrix(,nrow = n, ncol = nboot)
  for (i in 1:nboot){
    bootx[,i] <- sample(1:n, n, replace = TRUE)
  }
  bootr <- matrix(,nrow = n, ncol = nboot)
  for (i in 1:nboot){
    bootr[,i] <- sample(1:n, n, replace = TRUE)
  }
  cvfit <- cv.glmnet(x=X, y=y, alpha=1,intercept=FALSE,standardize=FALSE,nfolds = 10,nlambda=10)
  final <- glmnet(X,y,standardize = FALSE, alpha=1,lambda = cvfit$lambda.min, intercept = FALSE)
  beta <- as.vector(final$beta)
  M <- (beta != 0)
  X_boot <- as.matrix(X[,M])
  beta_boot <- solve(t(X_boot)%*%X_boot)%*%t(X_boot)%*%y
  res <- y-mean(y)-(X_boot-as.vector(apply(X_boot,2,mean)))%*%beta_boot
  X_star <- list()
  y_star <- list()
  for (j in 1:nboot){
    x_star <- X_boot[bootx[,j],]
    res_star <- res[bootx[,j],]
    y_star[[j]] <- x_star%*%beta_boot+res_star
    X_star[[j]] <- X[bootx[,j],]
  }
  returnList <- list("X" = X_star,
                     "y" = y_star
  )
  return(returnList)
}


