---
title: "Information"
author: "Erik Peter"
date: "Saturday, May 09, 2015"
output: html_document
---

## About

This is a [Shiny](http://shiny.rstudio.com/) interface for my R-package 
[fbroc](http://cran.r-project.org/web/packages/fbroc/index.html), which uses a very fast algorithm implemented 
in C++ to enable near real-time bootstrapping of the ROC curve and derived performance metrics such as the AUC.

#### Current features

* Very fast bootstrapping of ROC curves.
* Visualization of confidence regions for the ROC curve.
* Anaylsis of the AUC including confidence intervals. 

#### Planned feature

* Support for more performance metrics (partial AUC, true positive rate at fixed false positive rate, ...).
* Analysis of paired ROC curves to compare two classifiers.
* Help with finding a cutoff optimized for a specific application.

## Instructions

1. Use a tab-delimited text file as input (Excel can save tables in this format).
1. The text file must include a column with numerical values. Higher values are assumed to be associated
with the positive class.
1. It must also include a column with the classes. Denote the positive class with `TRUE` and
the negative class with `FALSE`.

If you want to install package fbroc on your R installation, please use 
`install.packages("fbroc")`.

#### Contact

If you have problems with or suggestions for either this shiny application or package fbroc please
contact me at <jerikpeter@googlemail.com>.
