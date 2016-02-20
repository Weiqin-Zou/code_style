#!/bin/bash

#get all pr18 and divide into use or not use cs part's pr18
#out:pr18.res,useCS_pr18.res and nouseCS_pr18.res
Rscript --slave get_pr18.R pr_17_metrics.res cb11_10_rmallNA.res useCSrepo.res pr18.res

#get cs 21 metrics and divide into use or not use cs part's cs21
#out:useCS_cs21.res and nouseCS_cs21.res
Rscript --slave get_cs21.R pr11_10_rmallNA.res cb11_10_rmallNA.res useCSrepo.res cs21.res
