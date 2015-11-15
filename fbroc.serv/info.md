---
title: "Instructions"
author: "Erik Peter"
date: "Sunday, November 15, 2015"
output: html_document
---

#### Test fbroc with example data

At startup the shiny app will use example dataset "roc.examples" included in fbroc. It 
includes four different predictors, two continuous and two discrete. 

#### Use your own data

1. Click on the checkbox "Upload data" to use your own data. 
1. Your data must be stored in tab-delimited text file (Excel can save tables in this format).
1. The text file must include a column with numerical values. Higher values are assumed to be associated
with the positive class.
1. It must also include a column with the true class labels. The positive class must be `TRUE` and
the negative class `FALSE`.
1. Select the correct columns from the dropdown selection above.

#### Contact

If you have problems with or suggestions for either this shiny application or package fbroc please
contact me at <jerikpeter@googlemail.com>.
