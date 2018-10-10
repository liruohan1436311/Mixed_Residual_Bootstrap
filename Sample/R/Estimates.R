#' @title Estimate Self-Specified Target Using Mixed Residual Bootstrap Samples
#'
#' @description This function will automatically generate the estimates of user-specified statistics using the mixed residual bootstrap method.
#' @param X The design matrix with dimension n by p, where n represents the number of observations and p represents the number of parameters.
#' @param y The n observations of the dependent variable y.
#' @param nboot Specify the number of Mixed Residual Bootstrap samples that you want to generate. Noted that the input should be a positive integar.
#' @param DefFunction It should be a function of X or y. The first input of DefFunction should be the bootstrapping X and the second input should be the bootstrapping y. Specifically, you may write DefFunction <- function(X_star,y_star){...}
#' @export
#' @seealso \code{\link[base]{paste}}
#' @return  Estimate It is a bootstrap estimate of your specified target. Estimate is a list and your estimated target can be a single value or a vector.
#' @return  se It is the standard error estimated by the bootstrap samples.
#' @references Lee, S. M. S. & Wu Y.L. (2017). A Bootstrap Recipe for Post-Model-Selection Inference
#' @examples \dontrun{
#' p <- 30
#' n <- 100
#' X <- matrix(rnorm(p*n),ncol = p,nrow = n)
#' beta <- as.vector(rnorm(p,10,4))
#' y <- X%*%beta+rnorm(n)
#' fun <- function(X,y){
#'  f <- solve(t(X)%*%X)%*%t(X)%*%y
#'  return(f)
#' }
#' estimates <- Sample::estimate(X,y,100,fun)
#'}
estimate <- function(X,y,nboot,DefFunction) {
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
  Estimate <- list()
  for (j in 1:nboot){
    x_star <- X_boot[bootx[,j],]
    res_star <- res[bootx[,j],]
    y_star[[j]] <- x_star%*%beta_boot+res_star
    X_star[[j]] <- X[bootx[,j],]
    Estimate[[j]] <- DefFunction(X_star[[j]],y_star[[j]])
  }
  returnList <- list("Esimate" = Estimate)
  return(returnList)
}


