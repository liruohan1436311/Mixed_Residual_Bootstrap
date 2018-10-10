# R Package: Mixed Residual Bootstrap
**This is a very useful R package to implement the Mixed Residual Bootstrap Method.**\\
For more detailed information regarding this method, please refer to the original research paper.\
*S M S Lee, Y Wu; A bootstrap recipe for post-model-selection inference under linear regression models, Biometrika, asy046, https://doi.org/10.1093/biomet/asy046*

## Install this R package from GitHub
1. Make sure that you have installed the R package "devtools":\
   If not, please use 
   ```R
   install.packages("devtools").
   ```
2. Install this R package: 
   ```R
   install_github("liruohan1436311/Mixed_Residual_Bootstrap", subdir="Sample")
   ```
3. Load the package: 
   ```R
   library(Sample)
   ```
4. Then, you may apply the following useful functions:\
   (1) 
   ```R
   Sample::generate(X,y,nboot)
   ```
### Description
It is a very useful function to generate Mixed Residual Bootstrap Samples. The default setting of model selection procedure in this version is 10-fold Cross-Validation LASSO. We will update the package to include more procedures later.
### Arguments

**X**&nbsp;&nbsp;&nbsp;The design matrix with dimension n by p, where n represents the number of observations and p represents the number of parameters.\
**y**&nbsp;&nbsp;&nbsp;The n observations of the dependent variable y.\
**nboot**	&nbsp;&nbsp;&nbsp;Specify the number of Mixed Residual Bootstrap samples that you want to generate. Noted that the input should be a positive integar.

### Value
**X**&nbsp;&nbsp;&nbsp;  A list of nboot bootstrapping design matrices\
**y**&nbsp;&nbsp;&nbsp; A list of nboot bootstrapping dependend variable observations

### Examples
```R
p <- 30
n <- 100
X <- matrix(rnorm(p*n),ncol = p,nrow = n)
beta <- as.vector(rnorm(p,10,4))
y <- X%*%beta+rnorm(n)
BootResult <- Sample::generate(X,y,100)
X_star <- BootResult$X
y_star <- BootResult$y
```

   
   (2) 
   ```R
   Sample::estimate(X,y,nboot,DefFunction)
   ```
###Description

This function will automatically generate the estimates of user-specified statistics using the mixed residual bootstrap method.

###Arguments

**X**&nbsp;&nbsp;&nbsp;	The design matrix with dimension n by p, where n represents the number of observations and p represents the number of parameters.\
**y**&nbsp;&nbsp;&nbsp;	The n observations of the dependent variable y.\
**nboot**&nbsp;&nbsp;&nbsp;	Specify the number of Mixed Residual Bootstrap samples that you want to generate. Noted that the input should be a positive integar.\
**DefFunction**&nbsp;&nbsp;&nbsp;	It should be a function of X or y. The first input of DefFunction should be the bootstrapping X and the second input should be the bootstrapping y. Specifically, you may write 
```R
DefFunction <- function(X_star,y_star){...}
```
###Value

**Estimate**&nbsp;&nbsp;&nbsp;  It is a bootstrap estimate of your specified target. Estimate is a list and your estimated target can be a single value or a vector.\

**se**&nbsp;&nbsp;&nbsp; It is the standard error estimated by the bootstrap samples.

###Examples
```R
p <- 30
n <- 100
X <- matrix(rnorm(p*n),ncol = p,nrow = n)
beta <- as.vector(rnorm(p,10,4))
y <- X%*%beta+rnorm(n)
fun <- function(X,y){
 f <- solve(t(X)%*%X)%*%t(X)%*%y
 return(f)
}
estimates <- Sample::estimate(X,y,100,fun)
```

5. For Further Information:\
Please feel free to send email to us <u3523358@connect.hku.hk>

