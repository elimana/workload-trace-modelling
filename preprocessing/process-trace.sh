#!/bin/bash

# This script takes a trace file '*.tr' and converts it into a 3 CSV files: 
# 'jobs.csv', 'tasks.csv' and 'workload.csv' for better job/task modeling and visualisation.


argc=$#-1
argv=( "$@" )
# echo "${argv[argc-2]}"

# Read trace file from argument
TRACE=$1
echo "Reading trace file: "$TRACE

DIR="./"
if [ $# -eq 2 ]; then
 DIR=$2
fi

# Generate jobs.csv
echo "Generating jobs.csv..."
awk 'BEGIN{FS=" "; print "\"job_id\",\"job_submission_time\",\"nr_of_tasks_in_job\",\"average_task_duration\""}{print NR-1","$1","$2","$3}' $TRACE > $DIR"jobs.csv"
echo "Generated jobs.csv with the fields: 'job_id', 'job_submission_time', 'nr_of_tasks_in_job', 'average_task_duration'"

# Generate tasks.csv
echo "Generating tasks.csv..."
# awk 'BEGIN{FS=" "}{out=NR-1","$4; for(i=5;i<=NF;i++){out=out"\n"NR-1","$i}; print out}' $TRACE | awk 'BEGIN{print "\"task_id\",\"job_id\",\"runtime_of_task\""}{print NR-1","$0}' > tasks.csv
# echo "Generated tasks.csv with the fields: 'task_id', 'job_id', 'runtime_of_task'"
awk 'BEGIN{FS=" "; print "\"job_submission_time\",\"runtime_of_task\""}{out=$1","$4; for(i=5;i<=NF;i++){out=out"\n"$1","$i}; print out}' $TRACE > $DIR"tasks.csv"
echo "Generated tasks.csv with the fields: 'job_submission_time', 'runtime_of_task'"

# Generate workload.csv
echo "Generating workload.csv..."
./gen-task-workload.py tasks.csv $DIR
echo "Generated workload.csv with the fields: 'time', 'nr_active_tasks'"
