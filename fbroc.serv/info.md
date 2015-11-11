---
title: "Information"
author: "Erik Peter"
date: "Saturday, May 28, 2015"
output: html_document
---

# NEEDS TO BE UPDATED

This is a [Shiny](http://shiny.rstudio.com/) interface for my R-package 
[fbroc](http://cran.r-project.org/web/packages/fbroc/index.html), which uses a very fast algorithm implemented 
in C++ to enable near real-time bootstrapping of the ROC curve and derived performance metrics such as the AUC.
This shiny app uses fbroc version 0.2.1.

#### Current features

* Very fast bootstrapping of ROC curves.
* Visualization of confidence regions for the ROC curve.
* Analysis of the AUC including confidence intervals.
* Investigate the TPR at a fixed FPR and vice versa.

#### Planned feature

* Support for more performance metrics (partial AUC).
* Analysis of paired ROC curves to compare two classifiers.
* Help with finding a cutoff optimized for a specific application.

## Instructions

### Example data

At startup the shiny app will work on the example dataset "roc.examples" included in fbroc. It 
includes four different predictors, two continuous and two discrete.

### Use your own data

1. Click on the checkbox "Upload data" to use your own data. 
1. Use a tab-delimited text file as input (Excel can save tables in this format).
1. The text file must include a column with numerical values. Higher values are assumed to be associated
with the positive class.
1. It must also include a column with the classes. Denote the positive class with `TRUE` and
the negative class with `FALSE`.

#### Contact

If you have problems with or suggestions for either this shiny application or package fbroc please
contact me at <jerikpeter@googlemail.com>.
