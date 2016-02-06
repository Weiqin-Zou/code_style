#!/bin/bash

./final_run_pr21metrics.sh "patch1-10000" > patch0-1w.log 2>&1&
./final_run_pr21metrics.sh "patch10001-20000" > patch1-2w.log 2>&1&
./final_run_pr21metrics.sh "patch20001-30000" > patch2-3w.log 2>&1&
./final_run_pr21metrics.sh "patch30001-40000" > patch3-4w.log 2>&1&
./final_run_pr21metrics.sh "patch40001-60000" > patch4-6w.log 2>&1&

