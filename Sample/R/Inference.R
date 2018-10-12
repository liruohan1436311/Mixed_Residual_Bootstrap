#' @title Statistical Inference Using Mixed Residual Bootstrap Samples
#'
#' @description This function will automatically provide the inference results using the mixed residual bootstrap method.
#' @param X The design matrix with dimension n by p, where n represents the number of observations and p represents the number of parameters.
#' @param y The n observations of the dependent variable y.
#' @param nboot Specify the number of Mixed Residual Bootstrap samples that you want to generate. Noted that the input should be a positive integar.
#' @param DefFunction It should be a function of X or y. The first input of DefFunction should be the bootstrapping X and the second input should be the bootstrapping y. Specifically, the output of the function must be a single value.
#' @param alpha The significance level. It should be a value between 0 and 1.
#' @param plotoption The default setting is TRUE. A density plot will be generated automatically. If you want to eliminate this option, please use plot=FALSE.
#' @export
#' @return lwb It is the lower bound of the confidence interval.
#' @return upb It is the upper bound of the confidence interval.
#' @return A distribution plot will be generated automatically.
#' @references Lee, S. M. S. & Wu Y.L. (2017). A Bootstrap Recipe for Post-Model-Selection Inference
#' @examples \dontrun{
#' p <- 30
#' n <- 100
#' X <- matrix(rnorm(p*n),ncol = p,nrow = n)
#' beta <- as.vector(rnorm(p,10,4))
#' y <- X%*%beta+rnorm(n)
#' fun <- function(X,y){
#'  f <- sum(solve(t(X)%*%X)%*%t(X)%*%y)
#'  return(f)
#' }
#' tt <- inference(X,y,100,fun,0.05,TRUE)
#' lwb <- tt$lwb
#' upb <- tt$upb
#'}
inference <- function(X,y,nboot,DefFunction,alpha,plotoption) {
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
  Estimate <- c()
  for (j in 1:nboot){
    x_star <- X_boot[bootx[,j],]
    res_star <- res[bootx[,j],]
    y_star[[j]] <- x_star%*%beta_boot+res_star
    X_star[[j]] <- X[bootx[,j],]
    Estimate[j] <- DefFunction(X_star[[j]],y_star[[j]])
  }
  lwb <- quantile(Estimate,alpha)
  upb <- quantile(Estimate,1-alpha)
  if (plotoption==TRUE){
    plot(density(Estimate),xlab="Bootstrap Estimates",
                   xlim=c(min(Estimate),max(Estimate)),col="red",main = paste("Density Plot of Bootstrap Estiamtes: alpha=",alpha,sep = ""),
                   lwd=2)
    abline(v = lwb, col="blue", lwd=2, lty=2)
    abline(v = upb, col="blue", lwd=2, lty=2)
  }
  returnList <- list("lwb" = lwb,
                     "upb" = upb)
  return(returnList)
}


