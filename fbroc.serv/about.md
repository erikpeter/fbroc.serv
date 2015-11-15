---
title: "About"
author: "Erik Peter"
date: "Sunday, November 15, 2015"
output: html_document
---

This is a [Shiny](http://shiny.rstudio.com/) interface for my R-package 
[fbroc](http://cran.r-project.org/web/packages/fbroc/index.html), which uses a very fast algorithm implemented 
in C++ to enable near real-time bootstrapping of the ROC curve and derived performance metrics such as the AUC.
This shiny app uses fbroc version 0.3.1.

#### Current features

* Very fast bootstrapping of ROC curves.
* Visualization of confidence regions for the ROC curve.
* Analysis of the AUC including confidence intervals.
* Investigate the TPR at a fixed FPR and vice versa.
* Compare two paired classifiers (not yet supported by the Shiny app)

#### Planned feature

* Support for more performance metrics (partial AUC).
* Help with finding a cutoff optimized for a specific application.
