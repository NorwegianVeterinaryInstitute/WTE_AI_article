# setting up R environment. As I have to rerun everything
# https://rstudio.github.io/renv/articles/renv.html 
library(renv)
# setup 
renv::init()

# reproducibility 
# renv.lock is the file with metadata on the packages - This is the file to share!
renv::snapshot() # updates the rlock file / metadata - after sure code works