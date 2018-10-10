# R Package: Mixed Residual Bootstrap
**This is a very useful R package to implement the Mixed Residual Bootstrap Method.**
For more detailed information regarding this method, please refer to the original research paper.
*S M S Lee, Y Wu; A bootstrap recipe for post-model-selection inference under linear regression models, Biometrika, asy046, https://doi.org/10.1093/biomet/asy046*

## Install this R package from GitHub
1. Make sure that you have installed the R package "devtools": 
   If not, use 
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
4. You may apply the following useful functions:
   * Item 4a Sample::generate(X,y,nboot)
   * Item 4b Sample::estimate(X,y,nboot,DefFunction)
